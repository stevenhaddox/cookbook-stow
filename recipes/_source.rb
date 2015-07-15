include_recipe 'tar'

Chef::Resource.send(:include, ::StowCookbook::Utils)
Chef::Recipe.send(:include, ::StowCookbook::Utils)
Chef::Resource.send(:include, ::StowCookbook::Command)
Chef::Recipe.send(:include, ::StowCookbook::Command)

potentially_at_compile_time do
  tarball = "#{node['stow']['path']}/src/stow-#{node['stow']['version']}.tar.gz"
  remote_file tarball do
    source node['stow']['src_url']
  end

  tar_package "file:///#{tarball}" do
    prefix "#{stow_buildout_path}"
    creates "#{stow_buildout_path}/bin/stow"
  end

  file "#{stow_buildout_path}/bin/stow" do
    owner 'root'
    group 'root'
    mode '0755'
  end

  # Remove old stow if directory exists
  execute 'destow_existing_stow' do
    packages = stow_package_versions('stow')
    packages.each do |package_basename|
      command "#{stow('buildout')} -D #{package_basename}"
    end
    # Do not run if current version of stow matches node specified version
    not_if do
      blank?(stow_package_versions('stow')) ||
        package_stowed?('stow', node['stow']['version'], 'bin/stow') == true
    end
  end

  # Stow current version of stow
  execute 'stow_stow' do
    stow_pkg_ver = "stow#{pkg_delim}#{node['stow']['version']}"
    command "#{stow('buildout')} #{stow_pkg_ver}"
    # Do not run if stow already exists where specified
    not_if do
      package_stowed?('stow', node['stow']['version'], 'bin/stow') == true
    end
  end
end
