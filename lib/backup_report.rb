require 'mail'
require "socket"

class BackupReport
  
  def initialize from = ENV['USER'],to = "root",mail_options = {}
    
    capture = STDCapture.capture do 
      yield
    end
    
    # Send email report
    mail = Mail.new
    mail.to to
    mail.from from
    mail.subject "Backup report"
    mail.body %@

     We are runnig on: #{Socket.gethostname}
     Below is the output log.

     ----
     #{capture}
     ----@
     
    mail.delivery_method.settings = mail.delivery_method.settings.merge(mail_options)
    mail.deliver!
    
  end
  
end