require 'spec_helper'
require 'env_setup/builder/input'

RSpec.describe EnvSetup::Builder::Input do
  let(:builder) { described_class.new(value, params) }

  context 'with existing input' do
    let(:params) { { 'INPUT1' => 'John' } }
    let(:value) { { 'input' => 'INPUT1' } }

    it 'builds var with input value' do
      expect(builder.call).to eq 'John'
    end
  end

  context 'without existing input' do
    let(:params) { { 'INPUT2' => 'John' } }
    let(:value) { { 'input' => 'INPUT1' } }

    it 'raises invalid input error' do
      expect { builder.call }.to raise_error(EnvSetup::InvalidInput)
    end
  end
end
