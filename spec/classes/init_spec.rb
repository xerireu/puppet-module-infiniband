require 'spec_helper'
describe 'infiniband' do

  context 'with defaults for all parameters' do
    it { should contain_class('infiniband') }
  end
end
