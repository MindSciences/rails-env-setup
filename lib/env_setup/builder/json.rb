# frozen_string_literal: true

require 'env_setup/builder/base'
require 'json'

module EnvSetup
  module Builder
    class Json < Base
      def call
        template.to_s
      end
    end
  end
end