include_recipe 'build-essential'

install_from_source = node['stow']['rpm_url'].nil? ? false : true
stow_rpm = "stow-#{node['stow']['version']}.rpm"
stow_rpm_path = "#{Chef::Config[:file_cache_path]}/#{stow_rpm}"
if install_from_source
  remote_file stow_rpm_path do
    source node['stow']['rpm_url']
    mode '0644'
    not_if { ::File.exist?(stow_rpm_path) }
  end
end

package 'stow' do
  if install_from_source
    Chef::Log.info "Installing stow from #{stow_rpm_path}"
    source stow_rpm_path
  end
end
