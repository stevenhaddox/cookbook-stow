include StowCookbook::Command
include StowCookbook::Utils
use_inline_resources

# :stow action
action :stow do
  name = new_resource.name
  version = new_resource.version
  creates = new_resource.creates
  # Destow existing > current version as latter is included in the former
  if new_resource.destow_existing == true
    destow_existing(name, version, creates)
  elsif !blank?(new_resource.current_version)
    destow_current_version(name, new_resource.current_version)
  end

  Chef::Log.debug ":stow package: #{name}#{pkg_delim}#{version}"
  execute "stow_#{name}#{pkg_delim}#{version}" do
    command "#{stow} #{name}#{pkg_delim}#{version}"
    # Do not run if stow is already the correct node version
    not_if do
      package_stowed?(name, version, creates) == true
    end
  end
  new_resource.updated_by_last_action(true)
end

# :destow action
action :destow do
  name = new_resource.name
  version = new_resource.version
  Chef::Log.debug ":destow package #{name}#{pkg_delim}#{version}"
  execute "destow_#{name}#{pkg_delim}#{version}" do
    command "#{stow} -D #{name}#{pkg_delim}#{version}"
    # Only destow the specified version if it exists in the stow directory path
    only_if do
      ::File.exist? "#{stow_path}/#{name}#{pkg_delim}#{version}"
    end
  end
  new_resource.updated_by_last_action(true)
end

# Destow currently stowed package
def destow_current_version(pkg_name = nil, old_version = nil)
  Chef::Log.debug "destow current ver: #{pkg_name}#{pkg_delim}#{old_version}"
  execute "destow_#{pkg_name}#{pkg_delim}#{old_version}" do
    command "#{stow} -D #{pkg_name}#{pkg_delim}#{old_version}"
    # Only destow the old version if it exists in the stow directory path
    only_if do
      ::File.exist? "#{stow_path}/#{pkg_name}#{pkg_delim}#{old_version}"
    end
  end
end

# Destow all package directories with "#{name}#{pkg_delim}" as a prefix
def destow_existing(pkg_name, version, creates)
  return [] if blank?(old_stow_packages(pkg_name, version))
  old_stow_packages(pkg_name, version).each do |package_basename|
    execute "destow_#{package_basename}" do
      command "#{stow} -D #{package_basename}"
      # Do not destow if the package is already the correct version
      # Or if there are no package versions to destow
      not_if do
        (package_stowed?(pkg_name, version, creates) == true) ||
          blank?(old_stow_packages(pkg_name, version))
      end
    end
  end
end
