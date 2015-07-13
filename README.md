# stow (Chef cookbook)

[![Supermarket](http://img.shields.io/cookbook/v/cookbook-stow.svg)][1]
[![Build Status](http://img.shields.io/travis/stevenhaddox/cookbook-stow.svg)][2]

## Description

A simple chef cookbook to install [GNU stow](https://www.gnu.org/software/stow/)
via package management or source if a package is not available.

## Resources Provided

The stow cookbook provides a `stow_package` resource that can be used as follows:

```ruby
stow_package 'openssl' do
  name    'openssl'
  version '1.0.2d'
  #action :stow # Also available `:destow`, the default action is `:stow`
  #current_version '1.0.2c' # Will result in current version being destowed before specified version is stowed
  #destow_existing false # USE WITH CAUTION! If true it will destow all sub-directories under the package "#{name}" directory
end
```

*NOTE*: This cookbook expects you to compile your packages with the following prefix convention:  
`#{node['stow']['path']}/#{package_name}/#{version}/`

For the example above, `openssl` would be compiled with the prefix:  
`--prefix #{node['stow']['path']}/openssl/1.0.2d/`

If your package / library works with the [tar cookbook][3] there's a very easy way to do this, like so:

```ruby
# Compile your package via the tar cookbook with proper prefix
tar_package "#{tarball_path_or_url}" do
  prefix "#{node['stow']['path']}/#{your_pkg_name}/#{your_pkg_version}"
  creates "#{node['stow']['path']}/#{your_pkg_name}/#{your_pkg_version}/bin/#{your_pkg_cmd}"
end

# Stow your package
stow_package "#{your_pkg_name}" do
  name    "#{your_pkg_name}"
  version "#{your_pkg_version}"
end
```

## Attributes

* `['stow']['path'] = '/usr/local/stow'`
  path stow command uses for symlinking packages and libraries
* `['stow']['target'] = nil`
  target directory for stow managed symlinks, defaults to stow path's parent directory if nil
* `['stow']['version'] = '2.2.0'`
  version of stow to install for source installations
* `['stow']['current_version'] = nil`
  current version of stow (to destow) when upgrading to a new version
* `['stow']['src_url'] = 'http://ftp.gnu.org/gnu/stow/stow-2.2.0.tar.gz'`
  URL for latest stow source tarball
* `['stow']['rpm_url'] = 'http://dl.fedoraproject.org/pub/epel/6/i386/stow-2.2.0-1.el6.noarch.rpm'`
  URL for latest RPM package
* `['stow']['deb_url'] = 'http://mirrors.kernel.org/ubuntu/pool/universe/s/stow/stow_2.2.0-2_all.deb'`
  URL for latest debian package

## Usage

Add the recipes to the `run_list`, it should probably be towards the beginning:

    "recipe[stow]"

Configure attributes:

    "stow" : {
      "path" : "/opt/local/stow",
      "version" : "2.2.0",
      "current_version" : "2.1.3"
    }

## ChefSpec Matchers

A set of ChefSpec matchers is included, for unit testing with ChefSpec. To illustrate:

```ruby
# Recipe code
stow_package 'openssl' do
  name    'openssl'
  version '1.0.2d'
end
```

```ruby
# Spec code
it 'should stow openssl version 1.0.2d' do
  expect(chef_run).to stow_package('openssl').with(
    name:    'openssl',
    version: '1.0.2d'
  )
  # Stow package wraps the execute resource if you want further validation
  expect(chef_run).to run_execute('stow_openssl-1.0.2d')
end
```

A matcher for the delete action is also available:

```ruby
# Recipe code
stow_package 'openssl' do
  action  :destow
  name    'openssl'
  version '1.0.2c'
end
```

```ruby
# Spec code
it 'should destow package openssl 1.0.2c' do
  expect(chef_run).to destow_package('openssl').with(
    action:  :destow,
    name:    'openssl',
    version: '1.0.2c'
  )
  # Stow package wraps the execute resource if you want further validation
  expect(chef_run).to run_execute('destow_openssl-1.0.2c')
end
```

[1]: https://supermarket.getchef.com/cookbooks/stow
[2]: http://travis-ci.org/stevenhaddox/cookbook-stow
[3]: https://supermarket.chef.io/cookbooks/tar
