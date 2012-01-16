module BackupPlugins
  module Mongo
   
   
    def all_mongo limit = 30

      # Check limit
      disk_usage_kb = (run_cmd "du /var/lib/mongodb/").match(/^([0-9]+)/).to_s.to_i

      raise "mongo limit reached limit:#{limit} disk_usage:#{disk_usage_kb/1000}" if disk_usage_kb > limit * 1000

      puts run_cmd "mkdir -p #{backup_target_dir}/mongo"

      puts run_cmd "cd #{backup_target_dir}/mongo/; mongodump --directoryperdb"

      puts "backup of mongo db on #{@server_domain}"
    end
    
  end
end