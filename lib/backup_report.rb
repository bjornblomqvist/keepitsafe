
require 'mail_builder'
require "socket"

class BackupReport
  
  def initialize from = ENV['USER'],to = "root",mail_options = {}
    
    backups = []
    
    Keepitsafe.after_backup do |backup,values|
      backups << backup
    end
    
    start_time = Time.now
    capture = STDCapture.capture do 
      yield
    end
    end_time = Time.now
    
    # Send email report
    mail = MailBuilder.new("#{File.dirname(__FILE__)}/../email/report").build({:backups => backups, :start_time => start_time, :end_time => end_time})
    mail.to to
    mail.from from
    mail.subject "Backup report: #{backups.select {|b| b.error != nil}.count} Error"
    mail.delivery_method.settings = mail.delivery_method.settings.merge(mail_options)
    mail.deliver!
    
    puts "\nSent backup report to: #{to}"
    
  end
  
end