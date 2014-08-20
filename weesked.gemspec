# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weesked/version'

Gem::Specification.new do |spec|
  spec.name          = "weesked"
  spec.version       = Weesked::VERSION
  spec.authors       = ["Igor Davydov"]
  spec.email         = ["iskiche@gmail.com"]
  spec.summary       = %q{Simple availialibility schedlule based on Redis lists}
  spec.description   = %q{Each time step has its redis list of booked objects}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5"
  spec.add_development_dependency "fakeredis", "~> 0.3"
end
