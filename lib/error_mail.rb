require 'mail'
require "socket"

class ErrorMail
  
  def self.setup from = ENV['USER'],to = "root",mail_options = {}
    
    Keepitsafe.on_error do |backup,options|

      mail = Mail.new
      mail.from from
      mail.to to
      mail.subject 'Backup error!'
      mail.body    %@

       Backup problems when backing up: #{backup.domain}
       We are runnig on: #{Socket.gethostname}

       #{options[:error].inspect}   
       #{options[:error].backtrace}@

      mail.delivery_method.settings = mail.delivery_method.settings.merge(mail_options)
      mail.deliver!

      puts "Error has been mailed to #{mail.to}!"
    end
    
  end
  
end