include_recipe 'tar'

potentially_at_compile_time do
  remote_file "#{node['stow']['path']}/src/stow-#{node['stow']['version']}.tar.gz" do
    source node['stow']['src_url']
  end

  tar_package "file:///#{node['stow']['path']}/src/stow-#{node['stow']['version']}.tar.gz" do
    prefix "#{node['stow']['path']}/stow-#{node['stow']['version']}"
    creates "#{node['stow']['path']}/stow-#{node['stow']['version']}/bin/stow"
  end


end
