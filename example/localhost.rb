gem 'keepitsafe'
require 'keepitsafe'

mail_options = eval(File.read(File.expand_path("~/.config/smtp.rb"))) # Read email options, same key names as for mail gem.

ErrorMail.setup("backup_script@yourdomain.com","you@yourdomain.com",mail_options)
BackupReport.new("backup_script@yourdomain.com","you@yourdomain.com",mail_options) do 
   
     Keepitsafe.new("localhost") do |backup|
     
       backup.all_mongo 750 # Throws an error if the db is biggar than 750 meg
       backup.all_postgres 100 # Throws an error if the db is biggar than 100 meg
     
       backup.files "/var/rails/yourapp/shared/uploads/"
       backup.tar_gz # Lets save some space
       backup.scp "backup.yourdomain.com" # Copy the backup of site
       backup.remove_old_backups
     
     end
end