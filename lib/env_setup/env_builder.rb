# frozen_string_literal: true

require 'env_setup'
require 'env_setup/builder/pattern'
require 'env_setup/builder/input'
require 'env_setup/builder/generator'
require 'env_setup/builder/nested_value'
require 'env_setup/builder/json'
require 'aws-sdk-secretsmanager'

module EnvSetup
  class EnvBuilder
    attr_accessor :inputs, :vars

    def initialize(inputs)
      @inputs = inputs
      @vars = {}
    end

    def build_json
      secrets = aws_secrets
      configuration.template.merge(secrets).each do |key, var_template|
        vars[key.to_s] = build_var(var_template)
      end
      vars
    end

    def build_var(var_template)
      return var_template unless var_template.is_a?(Hash)

      var_builder(var_template.transform_keys!(&:to_s)).call
    end

    private

    def var_builder(var_template)
      builder = [
        { builder: EnvSetup::Builder::Pattern, if: -> { var_template['pattern'] } },
        { builder: EnvSetup::Builder::NestedValue, if: -> { var_template['value'] } },
        { builder: EnvSetup::Builder::Input, if: -> { var_template['input'] } },
        { builder: EnvSetup::Builder::Generator, if: -> { var_template['generator'] } },
        { builder: EnvSetup::Builder::Json, if: -> { var_template.is_a?(Hash) } }
      ].find { |option| option[:if].call }

      raise "Invalid var builder: #{var_template.inspect}" unless builder

      builder[:builder].new(var_template, vars.merge(inputs))
    end

    def configuration
      EnvSetup.configuration
    end

    def aws_secrets
      return {} unless configuration.aws_ready?

      client = Aws::SecretsManager::Client.new(
        access_key_id: configuration.aws_access_key,
        secret_access_key: configuration.aws_secret_access_key,
        region: configuration.aws_region
      )

      secret_string = client.get_secret_value(secret_id: configuration.aws_secret_name).secret_string
      JSON.parse(secret_string).transform_values { |p| parse_aws_sm_value(p) }
    end

    def parse_aws_sm_value(value)
      JSON.parse(value)
    rescue JSON::ParserError
      value
    end
  end
end
