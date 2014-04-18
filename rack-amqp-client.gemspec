# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/amqp/client/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-amqp-client"
  spec.version       = Rack::AMQP::Client::VERSION
  spec.authors       = ["Joshua Szmajda", "John Nestoriak"]
  spec.email         = ["josh@optoro.com"]
  spec.description   = %q{An AMQP-HTTP ruby client}
  spec.summary       = %q{An AMQP-HTTP ruby client that relies on Bunny}
  spec.homepage      = "http://github.com/rack-amqp/rack-amqp-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bunny"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "emoji-rspec"
end
