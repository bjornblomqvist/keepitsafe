require 'rubygems'
require 'tempfile'
require 'net/ssh'
require 'net/scp'
require 'active_support/all'
require 'etc'

require "#{File.dirname(__FILE__)}/events.rb"
require "#{File.dirname(__FILE__)}/stdcapture.rb"
require "#{File.dirname(__FILE__)}/backup_report.rb"
require "#{File.dirname(__FILE__)}/error_mail.rb"
require "#{File.dirname(__FILE__)}/plugins/postgres.rb"
require "#{File.dirname(__FILE__)}/plugins/mongo.rb"
require "#{File.dirname(__FILE__)}/plugins/tar.rb"
require "#{File.dirname(__FILE__)}/plugins/rsync.rb"
require "#{File.dirname(__FILE__)}/plugins/files.rb"
require "#{File.dirname(__FILE__)}/plugins/scp.rb"
require "#{File.dirname(__FILE__)}/plugins/remove.rb"

class Keepitsafe
  
  include Events
  include BackupPlugins::Mongo
  include BackupPlugins::Postgres
  include BackupPlugins::Tar
  include BackupPlugins::Rsync
  include BackupPlugins::Files
  include BackupPlugins::Scp
  include BackupPlugins::Remove
  
  def initialize server_domain = "localhost", options = {}, &block
    
    @options = options
    @options[:username] ||= Etc.getlogin
    @options[:forward_agent] ||= true
    
    @server_domain = server_domain
    
    run &block if block_given?
  end
  
  def domain 
    @server_domain
  end
  
  def run &block
    
    puts "\n\n\t -- #{@server_domain} --\n\n"
    @backup_timastamp = Time.now.utc.strftime("%Y%m%d_%H%M.%S-UTC")
    
    
    if on_localhost?
      do_the_stuff &block if block_given?
    else
      Net::SSH.start( @server_domain , @options[:username] , :forward_agent => @options[:forward_agent]) do |ssh|
        @ssh = ssh
      
        do_the_stuff &block if block_given?
      
      end
    end 
  end
  
  def exist_on_server? path
    (run_cmd("ls #{path}") || '').match(/No such file or directory/).nil?
  end
  
  def upload src,target,create_target_dir = false
    src = run_cmd("echo #{src}").strip # expand "~/"
    target = `echo #{target}`.strip # expand "~/"
    puts "local:#{src} => remote:#{target}"
    
    run_cmd("mkdir -p #{target.end_with?("/") ? target : File.dirname(target)}" ) if create_target_dir
    
    if on_localhost?
      `cp -a #{src} #{target}`
    else
      @ssh.scp.upload!(src,target)
    end
  end
  
  def download_backup
    
    path = if !run_cmd("ls #{tar_path}").match(/No such file or directory/)
       tar_path
     elsif !run_cmd("ls #{tar_gz_path}").match(/No such file or directory/)
       tar_gz_path
     elsif !run_cmd("ls #{backup_target_dir}").match(/No such file or directory/)
       backup_target_dir
     else  
       raise "This code sucks as we cant find a file to transfer =("
     end
     
     puts "\n\t backup.download_backup()\n\n"
     download(path,path,true)
    
  end
  
  def download src,target,create_target_dir = false
    src = run_cmd("echo #{src}").strip # expand "~/"
    target = `echo #{target}`.strip # expand "~/"
    puts "remote:#{src} => local:#{target}"
    
    `mkdir -p #{target.end_with?("/") ? target : File.dirname(target)}` if create_target_dir
    
    if on_localhost?
      `cp -a #{src} #{target}`
    else
      @ssh.scp.download!(src,target)
    end
  end
  
  def upload_log    
    home_dir = run_cmd('echo ~')
    target_dir = "#{home_dir.strip}#{backup_target_dir[1..-1]}"
    if exist_on_server?(target_dir)
      puts "Uploading backup log"
      t = Tempfile.new('foo')
      t.write(log)
      t.close

      upload(t.path,"#{target_dir}"+"backup_log.txt")
      t.unlink
    else
      puts "Backup dir does not exist (any longer ?)"
    end
  end
  
  def log
    @log_buffer.string
  end
  
  def run_cmd cmd
    puts "run_cmd(#{@server_domain}): #{cmd}"
    if on_localhost?
      `#{cmd} 2>&1`
    else
      @ssh.exec! cmd
    end
  end
  
  def backup_target_dir
    "~/backups/#{@server_domain}/#{@backup_timastamp}/"
  end
  
  def create_backup_target_dir
     puts run_cmd "mkdir -p #{backup_target_dir}"
  end
  
  def create_pending_file
    puts run_cmd "touch #{backup_target_dir}/pending"
  end
  
  def remove_pending_file
    puts run_cmd "rm #{backup_target_dir}/pending"
  end
  
  def check_disk_left limit = 1000
    
    free = free_disk_space
    
    raise "root disk limit reached limit:#{limit} disk_free_on_root:#{free}" if free < limit
  end
  
  
  
  def on_localhost?
    @server_domain == "localhost"
  end
  
  attr_accessor :start_time, :end_time, :log_buffer, :error, :free_before, :free_after, :backup_size
  
  def set_backup_size remote_path
    
    raw = (run_cmd("du -hc #{remote_path}").gsub("\n",' ').gsub("\t",' ').strip.match(/([0-9kmgt.]{2,10})\s*total/i) || [0,"0"])[1]
    @backup_size = raw_to_meg(raw)
  end
  
  private 
  
  def create_backups_dir
     puts run_cmd "mkdir -p ~/backups/"
  end
  
  def free_disk_space
    disk_free_on_root = run_cmd('df -ha ~/backups/').scan(/([0-9MGT\.%]{2,10})/)[2].join("")
    
    disk_free_on_root = raw_to_meg(disk_free_on_root)
    
    disk_free_on_root.to_i
  end
  
  def raw_to_meg raw
    if raw.match(/t$/i)
      raw = raw.match(/(\d*)/)[1].to_f * 1000 * 1000
    elsif raw.match(/g$/i)
      raw = raw.match(/(\d*)/)[1].to_f * 1000 
    elsif raw.match(/k$/i)
      raw = raw.match(/(\d*)/)[1].to_f / 1000
    else
      raw = raw.match(/(\d*)/)[1].to_i
    end
  end
  
  def do_the_stuff
    @log_buffer = StringIO.new
  
    @start_time = Time.now
    begin
      STDCapture.capture(@log_buffer) do     
        
          create_backups_dir
          @free_before = free_disk_space
          trigger('before_backup')
        
          check_disk_left
          create_backup_target_dir
          create_pending_file
        
          yield self
      
          remove_pending_file
          
          upload_log

          @end_time = Time.now
          @free_after = free_disk_space
          set_backup_size(backup_target_dir) unless @backup_size
          trigger('after_backup')
      end
    rescue StandardError => e
      @error = e
      puts e.message
      puts e.inspect
      puts e.backtrace
      
      @log_buffer.puts e.message
      @log_buffer.puts e.inspect
      @log_buffer.puts e.backtrace
    
      trigger('on_error',{:error => e})
    end
  end
  
end
