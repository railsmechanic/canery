# encoding: utf-8

require File.expand_path('../lib/canery/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Railsmechanic"]
  gem.email         = ["info@railsmechanic.de"]
  gem.description   = %q{A simple but handy key/value store which is able to use a bunch of SQL databases as its backend.}
  gem.summary       = %q{Canery is a simple and easy to use key/value store with several commands to store and retrieve data. Because it uses a SQL database for storing the data, it can be used in many environments.}
  gem.homepage      = "https://github.com/railsmechanic/canery"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "canery"
  gem.require_paths = ["lib"]
  gem.version       = Canery::VERSION
  
  # dependencies
  gem.add_dependency "sequel", "~> 3.38.0"
  
  # development dependencies
  gem.add_development_dependency "rspec", ">= 2.11.0"
  gem.add_dependency "sqlite3-ruby", "~> 1.3.3"
end
