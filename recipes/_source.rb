include_recipe 'tar'

potentially_at_compile_time do
  tarball = "#{node['stow']['path']}/src/stow-#{node['stow']['version']}.tar.gz"
  remote_file tarball do
    source node['stow']['src_url']
  end

  tar_package "file:///#{tarball}" do
    prefix "#{node['stow']['path']}/stow/#{node['stow']['version']}"
    creates "#{node['stow']['path']}/stow/#{node['stow']['version']}/bin/stow"
  end

  stow_compile_path = "#{node['stow']['path']}/stow/#{node['stow']['version']}"

  file "#{stow_compile_path}/bin/stow" do
    owner 'root'
    group 'root'
    mode '0755'
  end

  stow_command  = "#{stow_compile_path}/bin/stow -d #{node['stow']['path']}"
  if node['stow']['target'] && !node['stow']['target'].empty?
    stow_command += " -t #{node['stow']['target']}"
  end

  # Remove old stow if directory exists
  execute 'destow_current_stow' do
    # Protect against nil attr value in `only_if` block error
    command "#{stow_command} -D stow/#{node['stow']['current_version']}"
    # Do not run if we do not have a current version attribute defined
    not_if do
      node['stow']['current_version'].nil? ||
        node['stow']['current_version'].empty?
    end
  end

  # Stow current version of stow
  execute 'stow_stow' do
    command "#{stow_command} stow/#{node['stow']['version']}"
  end
end
