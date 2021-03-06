module BackupPlugins
  module Scp
   
   
   
   def scp target_domain
   
     options = " -r "
     
     path = if !run_cmd("ls #{tar_path}").match(/No such file or directory/)
       tar_path
     elsif !run_cmd("ls #{tar_gz_path}").match(/No such file or directory/)
       tar_gz_path
     elsif !run_cmd("ls #{backup_target_dir}").match(/No such file or directory/)
       backup_target_dir
     else  
       raise "This code sucks as we cant find a file to transfer =(, target_domain: #{target_domain}"
     end
     
     puts "\n\t backup.scp(\"#{target_domain})\"\n\n"
     puts run_cmd("ssh #{target_domain} \"mkdir -p #{File.dirname(path)}\"")
     puts run_cmd("scp #{options} #{path} \"#{target_domain}:#{path}\"")
     
   end
    
  end
end