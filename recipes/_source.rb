include_recipe 'tar'

potentially_at_compile_time do
  remote_file "#{node['stow']['path']}/src/stow-#{node['stow']['version']}.tar.gz" do
    source node['stow']['src_url']
  end

  tar_package "file:///#{node['stow']['path']}/src/stow-#{node['stow']['version']}.tar.gz" do
    prefix "#{node['stow']['path']}/stow-#{node['stow']['version']}"
    creates "#{node['stow']['path']}/stow-#{node['stow']['version']}/bin/stow"
  end

  stow_compile_path = "#{node['stow']['path']}/stow-#{node['stow']['version']}"

  file "#{stow_compile_path}/bin/stow" do
    owner 'root'
    group 'root'
    mode '0755'
  end

  stow_command  = "#{stow_compile_path}/bin/stow -d #{node['stow']['path']}"
  stow_command += " -t #{node['stow']['target']}" if node['stow']['target']
  stow_command += " stow-#{node['stow']['version']}"

  execute 'stow_stow' do
    command stow_command
  end
end
