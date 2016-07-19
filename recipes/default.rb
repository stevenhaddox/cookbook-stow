#
# Cookbook Name:: stow
# Recipe:: default
#
# Copyright (c) 2015 Steven Haddox

execute 'create_stow_source_dir' do
  umask 022
  command "mkdir -p #{node['stow']['path']}/src"
  not_if { ::Dir.exist?("#{node['stow']['path']}/src") }
end

begin
  # Include OS platform speciic package installs
  include_recipe "stow::_#{node['platform_family']}"
rescue Chef::Exceptions::RecipeNotFound
  # If no platform match was found, install from source
  include_recipe 'stow::source'
end

template '/etc/profile.d/stow.sh' do
  action :create
  mode "#{node['stow']['profile.d']['mode']}" if node['stow']['profile.d']['mode']
end
