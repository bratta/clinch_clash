# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clinch_clash/version'

Gem::Specification.new do |spec|
  spec.name          = 'clinch_clash'
  spec.version       = ClinchClash::VERSION
  spec.authors       = ['Tim Gourley']
  spec.email         = ['tgourley@gmail.com']

  spec.summary       = '_why day 2013 - a toy decision making application'
  spec.description   = 'Let your decisions battle themselves out'
  spec.homepage      = 'https://github.com/bratta/clinch_clash'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Required Dependencies
  spec.add_dependency 'http', '~> 3.3.0'
  spec.add_dependency 'konfigyu', '~> 0.2.0'
  spec.add_dependency 'launchy', '~> 2.4.3'
  spec.add_dependency 'rainbow', '~> 3.0.0'

  # Development Dependencies
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug', '~> 10.0.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.59.2'
end
