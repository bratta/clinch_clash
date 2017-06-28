# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clinch_clash/version'

Gem::Specification.new do |spec|
  spec.name          = "clinch_clash"
  spec.version       = ClinchClash::VERSION
  spec.authors       = ["Tim Gourley"]
  spec.email         = ["tgourley@gmail.com"]
  spec.description   = %q{Let your decisions battle themselves out}
  spec.summary       = %q{_why day 2013 - a toy decision making application}
  spec.homepage      = "https://github.com/bratta/clinch_clash"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15.1"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "byebug"
  spec.add_dependency "http", "~> 2.2.2"
  spec.add_dependency "rainbow", "~> 2.2.2"
end
