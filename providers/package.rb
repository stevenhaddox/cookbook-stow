# Simplify variable existence checks with .blank?
def blank?
  self.nil? || self.empty?
end

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

# Detect which stow command to invoke
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

def stow
  "#{stow_command} #{stow_command_flags}"
end

# Destow all package directories with "#{name}-" as a prefix
def destow_existing
  # TODO
end

# Destow specified current version
def destow_current_version
  # TODO
end

action :stow do
  name = @new_resource.name
  version = @new_resource.version

  # Destow existing > current version as latter is included in the former
  if @new_resource.destow_existing == true
    destow_existing
  elsif !@new_resource.current_version.blank?
    destow_current_version
  end

  execute "stow_#{name}-#{version}" do
    command "#{stow} #{name}/#{version}"
  end
end

action :destow do
  name = @new_resource.name
  version = @new_resource.version

  execute "destow_#{name}-#{version}" do
    command "#{stow} -D #{name}/#{version}"
  end
end
