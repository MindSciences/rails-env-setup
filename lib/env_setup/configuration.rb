# frozen_string_literal: true

module EnvSetup
  class Configuration
    attr_accessor :aws_access_key, :aws_secret_access_key, :aws_region, :aws_secret_name,
                  :template, :env_name

    def aws_ready?
      aws_secret_name && aws_access_key && aws_secret_access_key
    end
  end
end
