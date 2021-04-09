
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mind_sciences/env_setup/version'

Gem::Specification.new do |spec|
  spec.name          = 'mind_sciences-env_setup'
  spec.version       = MindSciences::EnvSetup::VERSION
  spec.authors       = ['MindSciences']
  spec.email         = ['tech@mindsciences.com']

  spec.summary       = %q{Gem to setup MindSciences apps env}
  spec.description   = %q{Gem to setup MindSciences apps env}

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.2'
end
