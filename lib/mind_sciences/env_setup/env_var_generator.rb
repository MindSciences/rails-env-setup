require 'securerandom'

module MindSciences
  module EnvSetup
    class EnvVarGenerator
      def generate(method)
        raise 'Generator not found' unless respond_to?(method)
  
        send(method)
      end
  
      def host(env_name)
        "#{env_name}.mindsciences.net"
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