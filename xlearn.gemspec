require_relative "lib/xlearn/version"

Gem::Specification.new do |spec|
  spec.name          = "xlearn"
  spec.version       = XLearn::VERSION
  spec.summary       = "High performance factorization machines for Ruby"
  spec.homepage      = "https://github.com/ankane/xlearn-ruby"
  spec.license       = "Apache-2.0"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib,vendor}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.4"

  spec.add_dependency "ffi"
end
