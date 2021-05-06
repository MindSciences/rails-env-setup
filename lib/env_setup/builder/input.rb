# frozen_string_literal: true

require 'env_setup/builder/base'

module EnvSetup
  module Builder
    class Input < Base
      def call
        input_value = params[template['input']]
        valid?(input_value) ? input_value : invalid_error!(template)
      end

      def invalid_error!(input_name)
        raise EnvSetup::InvalidInput, "Required input #{input_name}"
      end

      def valid?(value)
        return false if value.nil?
        return false if value.is_a?(String) && value.strip.empty?

        true
      end
    end
  end
end
