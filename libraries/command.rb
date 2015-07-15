module StowCookbook
  # Methods to build proper stow command invocation
  module Command
    # package delimitert to try to group packages within stow directory
    def pkg_delim
      "-+-"
    end

    # Stow target path
    def stow_target
      blank?(node['stow']['target']) ? nil : node['stow']['target']
    end

    # Stow directory path
    def stow_path
      blank?(node['stow']['path']) ? nil : node['stow']['path']
    end

    # Stow buildout path - for stow source compile prefix
    def stow_buildout_path
      "#{node['stow']['path']}/stow#{pkg_delim}#{node['stow']['version']}"
    end

    # Stow target bin file check
    def stow_target_bin_exists?
      ::File.exist?("#{stow_target}/bin/stow")
    end

    # Stow path bin file check
    def stow_path_bin_exists?
      ::File.exist?("#{stow_path}/../bin/stow")
    end

    # Detect which stow command binary to invoke
    # Order of precedence: -t flag > -d flag > 'stow'
    def stow_command(use_buildout=false)
      if !blank?(stow_target) && stow_target_bin_exists?
        command = "#{stow_target}/bin/stow"
      elsif !blank?(stow_path) && stow_path_bin_exists?
        command = "#{stow_path}/../bin/stow"
      end

      # For the stow recipe it needs the buildout stow directly to stow itself
      if use_buildout == true
        command = "#{stow_buildout_path}/bin/stow"
      end

      command.nil? ? 'stow' : command
    end

    # Set stow command flags
    def stow_command_flags
      flags  = ''
      flags += "-t #{stow_target}" unless stow_target.nil?
      flags += "-d #{stow_path}" unless stow_path.nil?
      flags
    end

    # Wrap most specific stow binary & flags into a method
    def stow(use_buildout=false)
      "#{stow_command(use_buildout=use_buildout)} #{stow_command_flags}"
    end

    # List all package versions in stow's path directory
    def stow_package_versions(pkg_name=nil)
      package_versions = []
      # Iterate over directories that match name & delimiter
      Dir.glob("#{stow_path}/#{pkg_name}#{pkg_delim}*") do |pkg_path|
        package_versions << File.basename(pkg_path)
      end
      package_versions
    end

    # Determine if specified package version is already stowed
    # created_file should be a relative path to a file to check existence of
    # e.g., 'bin/openssl'
    def package_stowed?(pkg_name=nil, pkg_ver=nil, created_file=nil)
      package_installed = nil
      if File.exist?("#{stow_path}/#{created_file}") == false
        package_installed = false
      else
        # TODO
        package_installed = true # Temporary fix to get converge to run
        # Determine if the created file points to the proper version of the pkg
        # Detect lowest level symlink from created_file within stow_path

        # Compare symlink to package and version stow'd path
      end
      package_installed
    end
  end
end
