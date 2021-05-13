# frozen_string_literal: true

require 'env_setup/builder/base'
require 'securerandom'

module EnvSetup
  module Builder
    class Generator < Base
      def call
        raise 'Generator not found' unless respond_to?(template['generator'])

        send(template['generator'])
      end

      def secret
        SecureRandom.hex
      end

      def salt
        SecureRandom.hex(6)
      end
    end
  end
end
