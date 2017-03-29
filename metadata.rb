name 'stow'
maintainer 'Steven Haddox'
maintainer_email 'steven.haddox@gmail.com'
license 'MIT'
description 'Installs GNU Stow & provides stow_package resource'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/stevenhaddox/cookbook-stow'
issues_url 'https://github.com/stevenhaddox/cookbook-stow/issues'
version '2.0.0'

recipe 'stow::default', 'Install GNU stow via package or source (if needed)'
recipe 'stow::source', 'Install GNU stow via source installation'

depends 'apt'
depends 'build-essential'
depends 'tar'
depends 'yum-epel'

supports 'centos'
supports 'fedora'
supports 'redhat'
supports 'debian'
supports 'ubuntu'
supports 'scientific'
