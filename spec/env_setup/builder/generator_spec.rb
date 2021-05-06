require 'spec_helper'
require 'env_setup/builder/generator'

RSpec.describe EnvSetup::Builder::Generator do
  let(:builder) { described_class.new(value, params) }
  let(:params) { {} }

  describe 'salt generator' do
    let(:salt) { 'abc123' }
    let(:value) { { 'generator' => 'salt'} }

    before do
      allow(builder).to receive(:salt).and_return(salt)
    end

    it 'returns generated salt value' do
      expect(builder.call).to eq salt
    end
  end

  describe 'secret generator' do
    let(:secret) { 'abc1234567' }
    let(:value) { { 'generator' => 'secret'} }

    before do
      allow(builder).to receive(:secret).and_return(secret)
    end

    it 'returns generated secret value' do
      expect(builder.call).to eq secret
    end
  end
end
