require 'spec_helper'

describe 'stow_test::stow_package' do
  let(:stow_package_run) do
    ChefSpec::SoloRunner.new(
      :step_into => 'stow_package'
    ).converge(described_recipe)
  end

  context 'stow a package with only a name and version' do
    it 'stows package[foo]' do
      expect(stow_package_run).to stow_package('foo')
    end
  end
end
