# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smarty_streets/version'

Gem::Specification.new do |spec|
  spec.name          = "smarty_streets"
  spec.version       = SmartyStreets::VERSION
  spec.authors       = ["Russ Smith"]
  spec.email         = ["russ@bashme.org"]
  spec.description   = 'A ruby gem to integrate with http://www.smartystreets.com'
  spec.summary       = 'A ruby gem to integrate with http://www.smartystreets.com'
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.11"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "coveralls"
end
