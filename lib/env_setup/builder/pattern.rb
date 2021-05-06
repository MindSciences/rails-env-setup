# frozen_string_literal: true

require 'env_setup/builder/base'

module EnvSetup
  module Builder
    class Pattern < Base
      def call
        template['pattern'].gsub(regex, params.transform_keys { |key| "{{#{key}}}" })
      end

      private

      def regex
        Regexp.new(replacements.keys.map { |x| Regexp.escape("{{#{x}}}") }.join('|'))
      end

      def replacements
        occurrences.map do |oc|
          [oc, params[oc]]
        end.to_h
      end

      def occurrences
        template['pattern'].scan(/\{\{([^}]+)\}}(?:\z|[^}])/).flatten
      end
    end
  end
end
