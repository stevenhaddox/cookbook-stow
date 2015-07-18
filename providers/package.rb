include StowCookbook::Command
include StowCookbook::Utils
use_inline_resources

action :stow do
  name = new_resource.name
  version = new_resource.version
  # Destow existing > current version as latter is included in the former
  if new_resource.destow_existing == true
    destow_existing(name, version)
  elsif !blank?(new_resource.current_version)
    destow_current_version(name, new_resource.current_version)
  end

  execute "stow_#{name}#{pkg_delim}#{version}" do
    command "#{stow} #{name}#{pkg_delim}#{version}"
  end
  # TODO
  # not_if specified version is already stowed
  new_resource.updated_by_last_action(true)
end

action :destow do
  name = new_resource.name
  version = new_resource.version
  execute "destow_#{name}#{pkg_delim}#{version}" do
    command "#{stow} -D #{name}#{pkg_delim}#{version}"
  end
  # TODO
  # Only if specified version exists in stow path
  new_resource.updated_by_last_action(true)
end

# Destow currently stowed package
def destow_current_version(pkg_name = nil, old_version = nil)
  command "#{stow} -D #{pkg_name}#{pkg_delim}#{old_version}"
  # TODO
  # Only if specified version exists within stow path
end

# Destow all package directories with "#{name}#{pkg_delim}" as a prefix
def destow_existing(pkg_name = nil, version = nil)
  packages = old_stow_packages(pkg_name, version)
  return packages if blank?(packages)
  packages.each do |package_basename|
    command "#{stow} -D #{package_basename}"
  end
  # TODO
  # not_if specified version is already stowed
  #        or there are no packages in stow path
end
