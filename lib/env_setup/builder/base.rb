# frozen_string_literal: true

module EnvSetup
  module Builder
    class Base
      attr_accessor :template, :params

      def initialize(template, params)
        @template = template
        @params = params
      end
    end
  end
end
