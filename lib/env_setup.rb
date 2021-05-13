# frozen_string_literal: true

require 'env_setup/version'
require 'env_setup/configuration'

module EnvSetup
  class InvalidInput < StandardError; end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= EnvSetup::Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
