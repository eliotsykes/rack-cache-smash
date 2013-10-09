# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack-uncache/version'

Gem::Specification.new do |gem|
  gem.name          = "rack-uncache"
  gem.version       = Rack::Uncache::VERSION
  gem.authors       = ["Eliot Sykes"]
  gem.email         = ["e@jetbootlabs.com"]
  gem.description   = %q{Rack middleware to cache bust every CSS and JS asset request}
  gem.summary       = %q{Rack middleware to cache bust every CSS and JS asset request}
  gem.homepage      = "https://github.com/eliotsykes/rack-uncache"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
