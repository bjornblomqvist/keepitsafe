module BackupPlugins
  module Files
    def files path

      puts "\n\tbackup.files(#{path})\n"
      
      path = run_cmd("echo #{path}").strip # expand "~/"
      
      file_target_dir = "#{backup_target_dir}#{path}"
      
      run_cmd("mkdir -p #{file_target_dir}")

      cmd = "cp -a #{path} #{file_target_dir}"

      unless(run_cmd('which ionice').blank? || run_cmd('ionice -c3 ls').match(/ioprio_set: Operation not permitted/))
        cmd = "ionice -c3 #{cmd}"
      end
        
      puts run_cmd(cmd)

    end
  end
end