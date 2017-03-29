include_recipe 'build-essential'
include_recipe 'tar'

Chef::Resource.send(:include, ::StowCookbook::Utils)
Chef::Recipe.send(:include, ::StowCookbook::Utils)
Chef::Resource.send(:include, ::StowCookbook::Command)
Chef::Recipe.send(:include, ::StowCookbook::Command)

tarball = "#{node['stow']['path']}/src/stow-#{node['stow']['version']}.tar.gz"
remote_file tarball do
  source node['stow']['src_url']
end

tar_package "file:///#{tarball}" do
  prefix stow_buildout_path
  creates "#{stow_buildout_path}/bin/stow"
end

file "#{stow_buildout_path}/bin/stow" do
  owner 'root'
  group 'root'
  mode '0755'
end

# Remove old stow if directory exists
execute 'destow_stow' do
  target_version = node['stow']['version']
  old_stow_packages('stow', target_version).each do |package_basename|
    command "#{stow('buildout')} -D #{package_basename}"
  end
  # Do not destow if stow is already the correct node version
  # Or if there are no package versions to destow
  not_if do
    (package_stowed?('stow', node['stow']['version'], 'bin/stow') == true) ||
      blank?(old_stow_packages('stow', node['stow']['version']))
  end
end

# Stow current version of stow
execute 'stow_stow' do
  stow_pkg_ver = "stow#{pkg_delim}#{node['stow']['version']}"
  command "#{stow('buildout')} #{stow_pkg_ver}"
  # Do not run if stow is already the correct node version
  not_if do
    package_stowed?('stow', node['stow']['version'], 'bin/stow') == true
  end
end
