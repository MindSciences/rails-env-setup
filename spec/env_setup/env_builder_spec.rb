require 'json'
require 'spec_helper'
require 'env_setup/env_builder'

RSpec.describe EnvSetup::EnvBuilder do
  describe '.build_json' do
    let(:secret) { SecureRandom.hex }
    let(:salt) { SecureRandom.hex(2) }
    let(:template) do
      {
        'APP_NAME' => 'pr-123',
        'DOMAIN' => {
          'value' => 'foobar.com'
        },
        'APP_HOST' => {
          'pattern' => 'https://{{APP_NAME}}.{{DOMAIN}}'
        },
        'APP_SECRET' => {
          'generator' => 'secret'
        },
        'APP_PASSWORD' => {
          'generator' => 'salt'
        },
        'HOST' => { 'pattern' => 'wss://{{APP_NAME}}-community2-cable.{{DOMAIN}}/cable' },
        'INTEGRATION_APP_HOST' => {
          'input' => 'INTEGRATION_APP_HOST'
        },
        'INTEGRATION_APP_URL' => {
          'pattern' => '{{INTEGRATION_APP_HOST}}/api/integrate'
        },
        'WELCOME_MSG' => {
          'pattern' => 'Welcome {{USERNAME}}'
        },
        'DOMAINS' => {
          'APP' => ['abc.com', 'def.com'],
          'ADMIN' => ['abc-admin.com', 'def-admin.com']
        }
      }
    end

    context 'with aws secrets manager' do
      let(:inputs) do
        { 'INTEGRATION_APP_HOST' => 'https://integrate.foobar2.com', 'ENV_NAME' => 'PR-12345' }
      end
      let(:expected_json) do
        {
          'LANG' => 'en_US.UTF-8',
          'USERNAME' => 'foo',
          'HOST' => 'wss://pr-123-community2-cable.foobar.com/cable',
          'DOMAIN' => 'foobar.com',
          'APP_NAME' => 'pr-123',
          'APP_HOST' => 'https://pr-123.foobar.com',
          'APP_SECRET' => secret,
          'APP_PASSWORD' => salt,
          'INTEGRATION_APP_HOST' => inputs['INTEGRATION_APP_HOST'],
          'INTEGRATION_APP_URL' => "#{inputs['INTEGRATION_APP_HOST']}/api/integrate",
          'WELCOME_MSG' => 'Welcome foo',
          'DOMAINS' => '{"APP"=>["abc.com", "def.com"], "ADMIN"=>["abc-admin.com", "def-admin.com"]}'
        }
      end

      before do
        allow_any_instance_of(EnvSetup::Builder::Generator).to receive(:secret).and_return(secret)
        allow_any_instance_of(EnvSetup::Builder::Generator).to receive(:salt).and_return(salt)

        allow(EnvSetup).to receive(:configuration).and_return(
          EnvSetup::Configuration.new.tap do |config|
            config.template = template
            config.aws_access_key = 'aws_access_key'
            config.aws_secret_access_key = 'aws_secret_access_key'
            config.aws_region = 'aws_region'
            config.aws_secret_name = 'aws_secret_name'
          end
        )
        allow_any_instance_of(EnvSetup::EnvBuilder).to receive(:aws_secrets).and_return(
          {
            'LANG' => 'en_US.UTF-8',
            'USERNAME' => 'foo'
          }
        )
      end

      it 'generates env vars json' do
        expect(described_class.new(inputs).build_json).to eq expected_json
      end
    end

    context 'without aws secrets manager' do
      let(:inputs) do
        { 'INTEGRATION_APP_HOST' => 'https://integrate.foobar2.com', 'USERNAME' => 'foo' }
      end
      let(:expected_json) do
        {
          'APP_NAME' => 'pr-123',
          'DOMAIN' => 'foobar.com',
          'APP_HOST' => 'https://pr-123.foobar.com',
          'APP_SECRET' => secret,
          'APP_PASSWORD' => salt,
          'HOST' => 'wss://pr-123-community2-cable.foobar.com/cable',
          'INTEGRATION_APP_HOST' => inputs['INTEGRATION_APP_HOST'],
          'INTEGRATION_APP_URL' => "#{inputs['INTEGRATION_APP_HOST']}/api/integrate",
          'WELCOME_MSG' => 'Welcome foo',
          'DOMAINS' => '{"APP"=>["abc.com", "def.com"], "ADMIN"=>["abc-admin.com", "def-admin.com"]}'
        }
      end

      before do
        allow_any_instance_of(EnvSetup::Builder::Generator).to receive(:secret).and_return(secret)
        allow_any_instance_of(EnvSetup::Builder::Generator).to receive(:salt).and_return(salt)

        allow(EnvSetup).to receive(:configuration).and_return(
          EnvSetup::Configuration.new.tap do |config|
            config.template = template
          end
        )
      end

      it 'generates env vars json' do
        expect(described_class.new(inputs).build_json).to eq expected_json
      end
    end
  end

  describe '.build_var' do
    let(:inputs) { { 'MY_VAR' => 'Hey!', 'FOO' => 'bar', 'ENV_NAME' => 'env-test' } }
    let(:env_name) { 'env-test' }
    let(:template) { {} }
    let(:builder) { described_class.new(inputs) }

    before do
      EnvSetup.configure do |config|
        config.template = template
      end
    end

    describe 'simple value' do
      it 'returns same value' do
        expect(builder.build_var('foo')).to eq 'foo'
      end
    end

    describe 'nested value' do
      it 'returns same value' do
        expect(builder.build_var('value' => 'foo')).to eq 'foo'
      end
    end
  end
end
