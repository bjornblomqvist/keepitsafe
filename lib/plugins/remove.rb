
require 'date'

module BackupPlugins
  module Remove
    
    
    def remove paths,test_run = false
      
      puts "\n\tbackup.remove(#{paths},#{test_run})\n\n"
     
     paths = [paths] unless paths.is_a? Array
     
     raise "We are missing a block here!" unless block_given?
     
     paths.each do |path|
       
       backups = run_cmd("ls #{path}").strip.split("\n").map do |file_name|
         time_data = DateTime.strptime(file_name,'%Y%m%d_%H%M.%S').to_time.utc
         Time.utc(time_data.year,time_data.month,time_data.day,time_data.hour,time_data.min,time_data.sec,time_data.usec)
       end
       
       to_keep = (yield(backups) || []).uniq
       
       to_remove = backups.delete_if {|v| to_keep.include?(v) }
       
       to_remove.each do |backup_to_remove|
         
         cmd = "rm -rf #{path}/#{backup_to_remove.strftime("%Y%m%d_%H%M.%S")}*"
         
         if test_run
           puts cmd
         else
           run_cmd(cmd)
         end
         
       end

     end
   end
   
   def keep_first_each_month backups,time_back = 1.year.ago
     months = {}
     backups.sort.each do |time|
       if time > time_back
         months[time.strftime('%Y%m')] = time unless months[time.strftime('%Y%m')]
       end
     end
     
     months.values
   end
   
   def keep_first_each_week backups,time_back = 2.months.ago
     weeks = {}
     backups.sort.each do |time|
       if time > time_back
         string = time.strftime('%Y%m') + time.to_date.cweek.to_s
         weeks[string] = time unless weeks[string]
       end
     end
     
     weeks.values
   end
   
   def keep_first_each_day backups,time_back = 7.days.ago
     
     days = {}
     backups.sort.each do |time|
       if time > time_back
         string = time.strftime('%Y%m%d')
         days[string] = time unless days[string]
       end
     end
     
     days.values
   end
   
   def keep_all backups,time_back = 1.day.ago
     hours = []
      backups.sort.each do |time|
        if time > 1.days.ago
          hours << time
        end
      end
      
      hours
   end
   
    
 end
end