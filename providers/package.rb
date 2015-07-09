def stow
  if File.exists?("#{node['stow']['path']}/../bin/stow")
    stow_command = "#{node['stow']['path']}/../bin/stow"
  else
    stow_command = "stow"
  end
  stow_command += " -d #{node['stow']['path']}"
  if node['stow']['target'] && !node['stow']['target'].empty?
    stow_command += " -t #{node['stow']['target']}"
  end

  stow_command
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

  command "#{stow} #{name}-#{version}"
end

action :destow do
  name = @new_resource.name
  version = @new_resource.version

  command "#{stow} -D #{name}-#{version}"
end
