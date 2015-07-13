include StowCookbook::Utils
include StowCookbook::Command

use_inline_resources

# Destow all package directories with "#{name}-" as a prefix
def destow_existing
  # TODO
end

# Destow specified current version
def destow_current_version
  # TODO
end

action :stow do
  name = new_resource.name
  version = new_resource.version

  # Destow existing > current version as latter is included in the former
  if new_resource.destow_existing == true
    destow_existing
  elsif !new_resource.current_version.blank?
    destow_current_version
  end

  execute "stow_#{name}-#{version}" do
    command "#{stow} #{name}/#{version}"
  end

  new_resource.updated_by_last_action(true)
end

action :destow do
  name = new_resource.name
  version = new_resource.version

  execute "destow_#{name}-#{version}" do
    command "#{stow} -D #{name}/#{version}"
  end

  new_resource.updated_by_last_action(true)
end
