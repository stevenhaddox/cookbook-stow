module StowCookbook
  # Methods to build proper stow command invocation
  module Command
    # Wrap most specific stow binary & flags into a method
    def stow(type = nil)
      "#{stow_command(type)} #{stow_command_flags}"
    end

    # package delimitert to try to group packages within stow directory
    def pkg_delim
      '-+-'
    end

    # Stow target path
    def stow_target
      blank?(node['stow']['target']) ? nil : node['stow']['target']
    end

    # Stow directory path
    def stow_path
      blank?(node['stow']['path']) ? nil : node['stow']['path']
    end

    # List all package versions in stow's path directory
    def stow_package_versions(pkg_name = nil)
      package_versions = []
      # Iterate over directories that match name & delimiter
      Dir.glob("#{stow_path}/#{pkg_name}#{pkg_delim}*") do |pkg_path|
        package_versions << File.basename(pkg_path)
      end
      package_versions
    end

    # Determine if specified package version is already stowed
    # creates should be a relative path to a file to check existence of
    # e.g., 'bin/openssl'
    def package_stowed?(name = nil, version = nil, creates = nil)
      package_installed = nil
      if ::File.exist?("#{stow_path}/#{creates}") == false
        package_installed = false
      else
        # TODO Remove this incorrect assumption
        package_installed = true
        # Determine if the created file points to the proper version of the pkg
        # TODO
        # Detect lowest level symlink from created_file within stow_path
        # TODO
        # Compare symlink to package and version stow'd path
        # TODO
      end
      package_installed
    end

    # Detect which stow command binary to invoke
    # Order of precedence: -t flag > -d flag > 'stow'
    def stow_command(type = nil)
      if !blank?(stow_target) && stow_target_bin_exists?
        command = "#{stow_target}/bin/stow"
      elsif !blank?(stow_path) && stow_path_bin_exists?
        command = "#{stow_path}/../bin/stow"
      end

      # For the stow recipe it needs the buildout stow directly to stow itself
      command = "#{stow_buildout_path}/bin/stow" if type == 'buildout'

      command.nil? ? 'stow' : command
    end

    # Set stow command flags
    def stow_command_flags
      flags  = ''
      flags += "-t #{stow_target}" unless stow_target.nil?
      flags += "-d #{stow_path}" unless stow_path.nil?
      flags
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
  end
end
