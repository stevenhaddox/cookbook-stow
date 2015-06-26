#
# Cookbook Name:: stow
# Spec:: default
#
# Copyright (c) 2015 Steven Haddox

require 'spec_helper'

describe 'stow::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'creates stow src directory' do
      expect(chef_run).to create_directory('/opt/local/stow/src').with(
        user:  'root',
        group: 'root'
      )
    end
  end

  context 'When running on CentOS 6' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.5')
      runner.converge(described_recipe)
    end

    it 'installs stow' do
      expect(chef_run).to install_package 'stow'
    end
  end

  context 'When running on Fedora 20' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'fedora', version: '20')
      runner.converge(described_recipe)
    end

    it 'installs stow' do
      expect(chef_run).to install_package 'stow'
    end
  end

  context 'When running on Ubuntu 14' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)
    end

    it 'installs stow' do
      expect(chef_run).to install_package 'stow'
    end
  end

  context 'When running on Debian 7' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'debian', version: '7.0')
      runner.converge(described_recipe)
    end

    it 'installs stow' do
      expect(chef_run).to install_package 'stow'
    end
  end

  context "When installing from source" do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'opensuse', version: '12.3')
      runner.converge(described_recipe)
    end

    it 'gets the latest stow' do
      expect(chef_run).to create_remote_file("/opt/local/stow/src/stow-2.2.0.tar.gz")
    end

    it 'installs stow' do
      expect(chef_run).to install_package 'stow'
    end
  end

end
