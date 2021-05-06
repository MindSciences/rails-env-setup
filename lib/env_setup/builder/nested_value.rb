# frozen_string_literal: true

require 'env_setup/builder/base'

module EnvSetup
  module Builder
    class NestedValue < Base
      def call
        template['value']
      end
    end
  end
end
