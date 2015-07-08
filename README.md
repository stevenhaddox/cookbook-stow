# stow (Chef cookbook)

[![Supermarket](http://img.shields.io/cookbook/v/cookbook-stow.svg)][1]
[![Build Status](http://img.shields.io/travis/stevenhaddox/cookbook-stow.svg)][2]

## Description

A simple chef cookbook to install [GNU stow](https://www.gnu.org/software/stow/)
via package management or source if a package is not available.

## Attributes

* `['stow']['path'] = '/usr/local/stow'`
  path stow command uses for symlinking packages and libraries
* `['stow']['target'] = '/usr/local'`
  target directory for stow managed symlinks, defaults to stow path's parent directory
* `['stow']['version'] = '2.2.0'`
  current version of stow for source installations
* `['stow']['prev_version'] = nil`
  previous version of stow (to destow) when upgrading to a new version
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
      "prev_version" : "2.1.3"
    }

[1]: https://supermarket.getchef.com/cookbooks/stow
[2]: http://travis-ci.org/stevenhaddox/cookbook-stow
