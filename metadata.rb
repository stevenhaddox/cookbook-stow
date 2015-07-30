name 'stow'
maintainer 'Steven Haddox'
maintainer_email 'steven.haddox@gmail.com'
license 'MIT'
description 'Installs GNU Stow & provides stow_package resource'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/stevenhaddox/cookbook-stow'
issues_url 'https://github.com/stevenhaddox/cookbook-stow/issues'
version '0.3.1'

recipe 'stow::default', 'Install GNU stow via package or source (if needed)'
recipe 'stow::source', 'Install GNU stow via source installation'

depends 'apt', '~> 2.7.0'
depends 'build-essential', '~> 2.2'
depends 'tar', '~> 0.6.0'
depends 'yum-epel', '~> 0.6.2'

supports 'centos'
supports 'fedora'
supports 'redhat'
supports 'debian'
supports 'ubuntu'
supports 'scientific'
