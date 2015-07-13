# Stow target path
def stow_target
  stow_target = nil
  if node['stow']['target'] && !node['stow']['target'].empty?
    stow_target = node['stow']['target']
  end
  stow_target
end

# Stow directory path
def stow_path
  stow_path = nil
  if node['stow']['path'] && !node['stow']['path'].empty?
    stow_path = node['stow']['path']
  end
  stow_path
end

# Detect which stow command to invoke
# Order of precedence: -t flag > -d flag > 'stow'
def stow_command
  command = ''
  if target && !target.empty?
    if ::File.exists?("#{stow_target}/bin/stow")
      command = "#{stow_target}/bin/stow"
    end
  elsif stow_path && !stow_path.empty?
    if ::File.exists?("#{stow_path}/../bin/stow")
      command = "#{stow_path}/../bin/stow"
    end
  end
  command = command.nil? ? "stow" : command
end

# Set stow command flags
def stow_command_flags
  flags  = ''
  flags += "-t #{stow_target}" unless stow_target.nil?
  flags += "-d #{stow_path}" unless stow_path.nil?
end

def stow
  "#{stow_command} #{stow_command_flags}"
end

action :stow do
  name = @new_resource.name
  version = @new_resource.version

  # Destow existing > current version as latter is included in the former
  if @new_resource.destow_existing == true
    # Destow all package directories with "#{name}-" as a prefix
  elsif @new_resource.current_version && !@new_resource.current_version.empty?
    # Destow specified current version
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
