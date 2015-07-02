require 'spec_helper'

describe 'stow::default' do
  describe command('stow --version') do
    it "executes without error" do
      expect(subject.exit_status).to eq 0
    end
    it "is the right version" do
      expect(subject.stdout).to match(/version 2.2.0/)
    end
  end
end
