module StowCookbook
  # Methods to build proper stow command invocation
  module Command
    # Wrap most specific stow binary & flags into a method
    def stow(type = nil)
      Chef::Log.debug ".stow: #{stow_command(type)} #{stow_command_flags}"
      "#{stow_command(type)} #{stow_command_flags}"
    end

    # package delimiter to try to group packages within stow directory
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

    # Most specific stow target path
    def stow_resolved_target
      blank?(stow_target) ? "#{stow_path}/.." : stow_target
    end

    # List all outdated package versions in stow's path directory
    def old_stow_packages(pkg_name, version)
      old_versions = []
      # Iterate over directories that match name & delimiter
      Dir.glob("#{stow_path}/#{pkg_name}#{pkg_delim}*") do |pkg_path|
        old_versions << File.basename(pkg_path)
      end
      unless blank?(old_versions)
        # Remove the up to date package from array if it exists
        configured_version = ["#{pkg_name}#{pkg_delim}#{version}"]
        old_versions -= configured_version
      end
      Chef::Log.debug ".old_stow_packages: #{old_versions}"
      old_versions
    end

    # Determine if specified package version is already stowed
    # creates should be a relative path to a file to check existence of
    # e.g., 'bin/openssl'
    def package_stowed?(name, version, creates)
      package_stowed = nil
      if ::File.exist?("#{stow_resolved_target}/#{creates}")
        # Determine if the created file points to the proper version of the pkg
        package_stowed =
          ::File.realpath(stowed_symlink_path(creates))
          .include?("#{name}#{pkg_delim}#{version}")
      else
        # Creates file path is not found in the target path, package not stowed
        package_stowed = false
      end
      Chef::Log.debug ".package_stowed?: #{package_stowed}"
      package_stowed ? true : false
    end

    # rubocop:disable Metrics/MethodLength
    # Determine full path for currently stowed package
    def stowed_symlink_path(creates)
      stowed_symlink = nil
      creates_path = creates.split('/')
      creates_path.clone.each do
        # Detect lowest level symlink from created_file within stow_path
        if ::File.symlink?("#{stow_resolved_target}/#{creates_path.join('/')}")
          stowed_symlink = "#{stow_resolved_target}/#{creates_path.join('/')}"
          # Symlink found, break and use creates_path for stowed file
          # stowed_path = creates_path.join('/')
          break
        else
          # Remove lowest path if not a symlink
          creates_path.pop(1)
        end
      end

      Chef::Log.debug ".stowed_symlink_path: #{stowed_symlink}"
      stowed_symlink
    end

    # Detect which stow command binary to invoke
    # Order of precedence: -t flag > -d flag > 'stow'
    def stow_command(type = nil)
      command = nil
      if !blank?(stow_target) && stow_target_bin_exists?
        # Use the target path stow if it exists
        command = "#{stow_target}/bin/stow"
      elsif !blank?(stow_path) && stow_path_bin_exists?
        # Use the parent dir for stow path if it exists & there's no target
        command = "#{stow_path}/../bin/stow"
      end
      # Override to use the buildout path stow if specified
      command = "#{stow_buildout_path}/bin/stow" if type == 'buildout'
      # Default to PATH detected stow
      command ||= 'stow'

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
