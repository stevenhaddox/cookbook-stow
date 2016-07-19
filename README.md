# stow (Chef cookbook)

[![Cookbook Version](https://img.shields.io/cookbook/v/stow.svg)][supermarket]
[![Build Status](https://img.shields.io/travis/stevenhaddox/cookbook-stow.svg)][travis]
[![Code Climate](https://codeclimate.com/github/stevenhaddox/cookbook-stow/badges/gpa.svg)][codeclimate]

## Description

A simple chef cookbook to install [GNU stow](https://www.gnu.org/software/stow/)
via package management or source if a package is not available.

## Attributes

* `['stow']['path'] = '/usr/local/stow'`
  path stow command uses for symlinking packages and libraries
* `['stow']['target'] = nil`
  target directory for stow managed symlinks, defaults to stow path's parent directory if nil
* `['stow']['version'] = '2.2.0'`
  version of stow to install for source installations
* `['stow']['src_url'] = 'http://ftp.gnu.org/gnu/stow/stow-2.2.0.tar.gz'`
  URL for latest stow source tarball
* `['stow']['rpm_url'] = nil # 'http://dl.fedoraproject.org/pub/epel/6/i386/stow-2.2.0-1.el6.noarch.rpm'`
  Default is nil and uses yum, but you can specify an alternative rpm package by URL
* `['stow']['deb_url'] = nil # 'http://mirrors.kernel.org/ubuntu/pool/universe/s/stow/stow_2.2.0-2_all.deb'`
  Default is nil and uses apt, but you can specify an alternative deb package by URL
* `['stow']['profile.d']['mode'] = nil`
  Default is nill which will set permissions to the default system level

## Usage

Add the recipes to the `run_list`, it should probably be towards the beginning:

    "recipe[stow]"

Configure attributes:

    "stow" : {
      "path" : "/opt/local/stow",
      "version" : "2.2.0"
    }

## Resources Provided

The stow cookbook provides a `stow_package` resource that can be used as follows:

```ruby
stow_package 'openssl' do
  name    'openssl'
  version '1.0.2d'
  creates 'bin/openssl' # *Required* relative path to a file your source compiled package creates
  #action :stow # Also available `:destow`, the default action is `:stow`
  #destow_existing true # Defaults to `true` and will destow all out of date packages with prefix "#{name}-+-"
  #current_version '1.0.2c' # Destows `current_version` before `version` is stowed; ignored unless `destow_existing` is `false`
end
```

*NOTE*: This cookbook expects you to compile your packages with the following prefix convention:  
`#{node['stow']['path']}/#{package_name}-+-#{version}/`

For the example above, you would compile `openssl` with the prefix:  
`--prefix #{node['stow']['path']}/openssl-+-1.0.2d/`

If your package / library works with the [tar cookbook][tar] there's a very easy way to do this, like so:

```ruby
# Compile your package via the tar cookbook with proper prefix
tar_package "#{tarball_path_or_url}" do
  prefix "#{node['stow']['path']}/#{your_pkg_name}-+-#{your_pkg_version}"
  creates "#{node['stow']['path']}/#{your_pkg_name}-+-#{your_pkg_version}/#{path/to/pkg/file}"
end

# Stow your package
stow_package "#{your_pkg_name}" do
  name    "#{your_pkg_name}"
  version "#{your_pkg_version}"
  creates 'path/to/pkg/file' # Note the relative path vs full path for `tar_package`
end
```

## ChefSpec Matchers

A set of ChefSpec matchers is included, for unit testing with ChefSpec. To illustrate:

```ruby
# Recipe code
stow_package 'openssl' do
  name    'openssl'
  version '1.0.2d'
  creates 'bin/openssl'
end
```

```ruby
# Spec code
it 'should stow openssl version 1.0.2d' do
  expect(chef_run).to stow_package('openssl').with(
    name:    'openssl',
    version: '1.0.2d',
    creates: 'bin/openssl'
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
  creates 'bin/openssl'
end
```

```ruby
# Spec code
it 'should destow package openssl 1.0.2c' do
  expect(chef_run).to destow_package('openssl').with(
    action:  :destow,
    name:    'openssl',
    version: '1.0.2c',
    creates: 'bin/openssl'
  )
  # Stow package wraps the execute resource if you want further validation
  expect(chef_run).to run_execute('destow_openssl-1.0.2c')
end
```

[supermarket]: https://supermarket.getchef.com/cookbooks/stow
[travis]: http://travis-ci.org/stevenhaddox/cookbook-stow
[codeclimate]: https://codeclimate.com/github/stevenhaddox/cookbook-stow
[tar]: https://supermarket.chef.io/cookbooks/tar
