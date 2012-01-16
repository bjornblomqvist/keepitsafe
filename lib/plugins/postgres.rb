module BackupPlugins
  module Postgres
   
   def all_postgres limit = 500

     # Check limit
     cluster_size_in_bytes = run_cmd('env psql postgres -c "SELECT sum(pg_database_size(pg_database.datname)) AS cluster_size FROM pg_database;"').match(/([0-9]{5,16})/).to_s.to_i
     raise "postgres limit reached limit:#{limit} cluster_size:#{cluster_size_in_bytes/1000/1000}" if cluster_size_in_bytes > limit * 1000 * 1000

     puts run_cmd "mkdir -p #{backup_target_dir}/postgres"

     puts run_cmd "cd #{backup_target_dir}/postgres/; pg_dumpall > dumpall.pg.sql"

     puts "backup of postgres db on #{@server_domain}"
   end
   
  end
end