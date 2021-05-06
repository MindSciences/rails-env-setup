lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'env_setup/version'

Gem::Specification.new do |spec|
  spec.name          = 'env_setup'
  spec.version       = EnvSetup::VERSION
  spec.authors       = ['Jonatas Daniel Hermann']
  spec.email         = ['jonatas@mindsciences.com']

  spec.summary       = %q{Gem to setup apps env}
  spec.description   = %q{Gem to setup apps env}

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = ['env_setup']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.2'
  spec.add_runtime_dependency 'aws-sdk-secretsmanager', '~> 1.0'
end
