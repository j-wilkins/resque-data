# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resque-data/version'

Gem::Specification.new do |gem|
  gem.name          = "resque-data"
  gem.version       = Resque::Data::VERSION
  gem.authors       = ["j-wilkins"]
  gem.email         = ["pablo_honey@me.com"]
  gem.description   = %q{Make Resque data accessible via HTTP.}
  gem.summary       = %q{Make Resque data accessible via HTTP.}
  gem.homepage      = "https://github.com/j-wilkins/resque-data"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "sinatra"
  gem.add_dependency "rack-cors"
  gem.add_dependency "redis-namespace"

end
