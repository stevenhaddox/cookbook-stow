require 'spec_helper'

describe 'stow_test::stow_package' do
  let(:stow_package_run) do
    ChefSpec::SoloRunner.new(
      :step_into => 'stow_package'
    ).converge(described_recipe)
  end

  context 'stow a package with only a name and version' do
    it 'stows stow_package[foo]' do
      expect(stow_package_run).to stow_package('foo').with(
        name: 'foo',
        version: '1.0.0'
      )
    end
  end

  context 'destows a package with name, version, and action' do
    it 'destows stow_package[foo]' do
      expect(stow_package_run).to destow_package('foo').with( action: :destow, name: 'foo', version: '1.0.0' )
    end
  end
end
