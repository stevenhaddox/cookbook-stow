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
        # Determine if the created file points to the proper version of the pkg
        # Detect lowest level symlink from created_file within stow_path
        package_installed =
          !!(::File.realpath(stowed_symlink_path(creates))
            .match("#{name}#{pkg_delim}#{version}")
            )
      end
      package_installed
    end

    # Determine full path for currently stowed package
    def stowed_symlink_path(creates = nil)
      stowed_path = nil
      creates.split('/').each do
        # Compare symlink version to desired version
        if ::File.symlink?("#{stow_path}/#{path_elements.join('/')}")
          # Symlink found, return path
          stowed_path = path_elements.join('/')
          break
        else
          # Remove lowest path if not a symlink
          path_elements.pop(1)
        end
      end

      stowed_path
    end

    # Detect which stow command binary to invoke
    # Order of precedence: -t flag > -d flag > 'stow'
    def stow_command(type = nil)
      # Default to PATH detected stow
      command = 'stow'
      # Override to use the buildout path stow if specified
      command = "#{stow_buildout_path}/bin/stow" if type == 'buildout'
      if !blank?(stow_target) && stow_target_bin_exists?
        # Use the target path stow if it exists
        command = "#{stow_target}/bin/stow"
      elsif !blank?(stow_path) && stow_path_bin_exists?
        # Use the parent dir for stow path if it exists & there's no target
        command = "#{stow_path}/../bin/stow"
      end

      command
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
