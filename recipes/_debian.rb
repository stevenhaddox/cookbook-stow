include_recipe 'apt'
include_recipe 'build-essential'

install_from_source = node['stow']['deb_url'].nil? ? false : true
stow_deb = "stow-#{node['stow']['version']}.deb"
stow_deb_path = "#{Chef::Config[:file_cache_path]}/#{stow_deb}"
if install_from_source
  remote_file stow_deb_path do
    source node['stow']['deb_url']
    mode '0644'
    not_if { ::File.exist?(stow_deb_path) }
  end
  # In order to install from source, dpkg is needed
  dpkg_package 'stow' do
    Chef::Log.info "Installing stow from #{stow_deb_path}"
    source stow_deb_path
  end
else
  # dpkg is lower level than apt-get, use package for apt
  package 'stow'
end
