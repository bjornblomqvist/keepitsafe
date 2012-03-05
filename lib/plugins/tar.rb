module BackupPlugins
  module Tar
    
    def tar_path
      "#{backup_target_dir[0..-2]}.tar"
    end
    
    def tar_gz_path
      "#{backup_target_dir[0..-2]}.tar.gz"
    end
    
    def tar options = {:keep_files => false}
      puts "\n\tTaring files"
      puts run_cmd "cd #{backup_dir_path}; tar -cf #{tar_path} #{backup_dir_name}"
      unless options[:keep_files]
        puts "\n\tRemoving backup dir" 
        puts run_cmd "rm -rf #{backup_target_dir}" 
      end
    end
    
    def tar_gz options = {:keep_files => false}
      puts "\n\tTaring and gziping files\n\n"
      puts run_cmd "cd #{backup_dir_path}; tar -czf #{tar_gz_path} #{backup_dir_name}"
      
      unless options[:keep_files]
        puts "\n\tRemoving backup dir" 
        puts run_cmd "rm -rf #{backup_target_dir}" 
      end
      
      set_backup_size(tar_gz_path)
    end
    
    private 
    
    def backup_dir_path
      File.dirname(backup_target_dir)
    end
    
    def backup_dir_name
      File.basename(backup_target_dir)
    end
  end
end