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
      expect(chef_run).to run_execute('create_stow_source_dir')
    end

    it 'adds stow bin to $PATH' do
      expect(chef_run).to create_template('/etc/profile.d/stow.sh')
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

  context 'When installing from source' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'opensuse', version: '12.3')
      runner.converge(described_recipe)
    end

    it 'gets the latest stow' do
      expect(chef_run).to create_remote_file("/usr/local/stow/src/stow-2.2.0.tar.gz")
    end

    it 'installs stow from source' do
      expect(chef_run).to install_tar_package("file:////usr/local/stow/src/stow-2.2.0.tar.gz")
    end

    describe '.stow_stow' do
      it 'runs on a clean install' do
        expect(chef_run).to run_execute('stow_stow')
      end

      it 'is skipped if stow is up to date' do
        # Stub package_stowed? to return true
        allow_any_instance_of(Chef::Resource::Execute).to receive(:package_stowed?).and_return(true)
        expect(chef_run).to_not run_execute('stow_stow')
      end
    end

    describe '.destow_stow' do
      it 'is skipped if stow is up to date' do
        # Stub package_stowed? to return true
        allow_any_instance_of(Chef::Resource::Execute).to receive(:package_stowed?).and_return(true)
        expect(chef_run).to_not run_execute('destow_stow')
      end

      it 'is skipped if old_stow_packages is blank' do
        # Stub package_stowed? to return false
        allow_any_instance_of(Chef::Resource::Execute).to receive(:package_stowed?).and_return(true)
        # Stub the directory glob to return no package matches
        allow_any_instance_of(Chef::Resource::Execute).to receive(:old_stow_packages).and_return([])
        expect(chef_run).to_not run_execute('destow_stow')
      end

      it 'should destow existing stow packages' do
        # Return array of stow packages that exist in stow's path
        allow_any_instance_of(Chef::Resource::Execute).to receive(:old_stow_packages).and_return(['/usr/local/stow/stow-+-2.1.3'])
        # Ensure the directory glob returns the proper package
        allow(::File).to receive(:exist?).and_call_original
        allow(::File).to receive(:exist?).with('/usr/local/stow/stow-+-2.1.3').and_return(true)
        # Ensure the correct files are present
        # Ensure the symlink is detected
        expect(chef_run).to run_execute('destow_stow')
        expect(chef_run).to run_execute('stow_stow')
      end
    end
  end
end
