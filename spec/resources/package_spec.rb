require 'spec_helper'

describe 'stow_test::stow_package' do
  let(:stow_package_run) do
    ChefSpec::SoloRunner.new(
      step_into: 'stow_package'
    ).converge(described_recipe)
  end

  it 'converges successfully' do
    stow_package_run # This should not raise an error
  end

  context 'stow a package with required attributes' do
    it 'stows stow_package[foo]' do
      expect(stow_package_run).to stow_package('foo').with(
        name: 'foo',
        version: '1.0.0',
        creates: 'foo/tmp.txt'
      )
      expect(stow_package_run).to run_execute('stow_foo-+-1.0.0')
    end
  end

  context 'destow a non-existent package' do
    it 'does not destow a non-existent package' do
      # Stub the required package directory to return false on existence check
      allow(::File).to receive(:exist?).and_call_original
      allow(::File).to receive(:exist?).with('/usr/local/stow/foo-+-1.0.0').and_return(false)
      expect(stow_package_run).to destow_package('foo').with(
        action: [:destow],
        name: 'foo',
        version: '1.0.0',
        creates: 'foo/tmp.txt'
      )
      expect(stow_package_run).to_not run_execute('destow_foo-+-1.0.0')
    end
  end

  context 'destows a package with required attributes' do
    it 'destows stow_package[foo]' do
      # Stub the required package directory to return true on existence check
      allow(::File).to receive(:exist?).and_call_original
      allow(::File).to receive(:exist?).with('/usr/local/stow/foo-+-1.0.0').and_return(true)
      expect(stow_package_run).to destow_package('foo').with(
        action: [:destow],
        name: 'foo',
        version: '1.0.0',
        creates: 'foo/tmp.txt'
      )
      expect(stow_package_run).to run_execute('destow_foo-+-1.0.0')
    end
  end
end
