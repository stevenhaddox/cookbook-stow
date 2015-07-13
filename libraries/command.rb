module StowCookbook
  # Methods to build proper stow command invocation
  module Command
    include Chef::DSL::IncludeRecipe

    # Stow target path
    def stow_target
      node['stow']['target'].blank? ? nil : node['stow']['target']
    end

    # Stow directory path
    def stow_path
      node['stow']['path'].blank? ? nil : node['stow']['path']
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
    def stow_command
      if !stow_target.blank? && stow_target_bin_exists?
        command = "#{stow_target}/bin/stow"
      elsif !stow_path.blank? && stow_path_bin_exists?
        command = "#{stow_path}/../bin/stow"
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
    def stow
      "#{stow_command} #{stow_command_flags}"
    end
  end
end
