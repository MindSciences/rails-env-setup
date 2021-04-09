require 'mind_sciences/env_setup'
require 'mind_sciences/env_setup/env_var_generator'

module MindSciences
  module EnvSetup
    class Generator
      attr_reader :env_name, :inputs, :template

      def initialize(env_name, template, inputs)
        @env_name = env_name
        @template = template
        @inputs = inputs
      end

      def generate_json
        validate_inputs!(inputs)

        template.transform_values do |value|
          env_value(value)
        end
      end

      def env_value(value)
        return value unless value.is_a?(Hash)
        return value['value'] if value['value']
        return EnvVarGenerator.new.host(env_name) if value['type'] == 'host'
        return EnvVarGenerator.new.generate(value['generator']) if value['generator']
        return input(value) if value['input']
      end

      private

      def input(value)
        input_name = value['input']
        input_value = inputs[input_name]
        valid_input?(input_value) ? input_value : invalid_input_error!(input_name)
      end

      def validate_inputs!(inputs)
        %w(env-name).each do |k|
          invalid_input_error!(k) unless valid_input?(inputs[k])
        end
      end

      def invalid_input_error!(input_name)
        raise MindSciences::EnvSetup::InvalidInput, "Required input #{input_name}"
      end

      def valid_input?(value)
        return false if value.nil?
        return false if value.is_a?(String) && value.strip.empty?
        true
      end
    end
  end
end
