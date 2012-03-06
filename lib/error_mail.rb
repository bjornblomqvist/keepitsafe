require 'mail'
require "socket"

class ErrorMail
  
  def self.setup from = ENV['USER'],to = "root",mail_options = {}
    
    Keepitsafe.on_error do |backup,options|

      mail = MailBuilder.new("#{File.dirname(__FILE__)}/../email/error").build({:backup => backup})
      mail.from from
      mail.to to
      mail.subject "[#{backup.domain}] Backup ERROR!"
      mail.delivery_method.settings = mail.delivery_method.settings.merge(mail_options)
      mail.deliver!

      puts "\nError has been mailed to #{mail.to}!"
    end
    
  end
  
end