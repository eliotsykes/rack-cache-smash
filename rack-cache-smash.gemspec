# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack-cache-smash/version'

Gem::Specification.new do |gem|
  gem.name          = "rack-cache-smash"
  gem.version       = Rack::CacheSmash::VERSION
  gem.authors       = ["Eliot Sykes"]
  gem.email         = ["e@jetbootlabs.com"]
  gem.description   = %q{Rack middleware to cache bust every CSS and JS asset request}
  gem.summary       = %q{Rack middleware to cache bust every CSS and JS asset request}
  gem.homepage      = "https://github.com/eliotsykes/rack-cache-smash"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
