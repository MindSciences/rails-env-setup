require 'spec_helper'
require 'mind_sciences/env_setup/generator'

RSpec.describe MindSciences::EnvSetup::Generator do
  describe '.env_value' do
    let(:inputs) { { 'my-var' => 'Hey!' } }
    let(:template) { {} }
    let(:generator) { described_class.new('env-test', template, inputs) }

    describe 'simple value' do
      it 'returns same value' do
        expect(generator.env_value('foo')).to eq 'foo'
      end
    end

    describe 'nested value' do
      it 'returns same value' do
        expect(generator.env_value('value' => 'foo')).to eq 'foo'
      end
    end

    describe 'value with host type' do
      it 'returns generator host with env name' do
        expect(generator.env_value('type' => 'host')).to eq 'env-test.mindsciences.net'
      end
    end

    describe 'input value' do
      context 'with valid input' do
        it 'returns value passed as input' do
          expect(generator.env_value('input' => 'my-var')).to eq inputs['my-var']
        end
      end
      context 'with not found input' do
        it 'raises an error' do
          expect { generator.env_value('input' => 'some-var') }.to raise_error(MindSciences::EnvSetup::InvalidInput)
        end
      end
    end

    describe 'salt generator' do
      let(:salt) { 'abc123' }
      before do
        allow_any_instance_of(MindSciences::EnvSetup::EnvVarGenerator).to receive(:salt).and_return(salt)
      end

      it 'returns generated salt value' do
        expect(generator.env_value('generator' => 'salt')).to eq salt
      end
    end

    describe 'secret generator' do
      let(:secret) { 'abc1234567' }
      before do
        allow_any_instance_of(MindSciences::EnvSetup::EnvVarGenerator).to receive(:secret).and_return(secret)
      end

      it 'returns generated secret value' do
        expect(generator.env_value('generator' => 'secret')).to eq secret
      end
    end
  end
end
