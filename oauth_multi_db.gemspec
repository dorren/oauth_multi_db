# -*- encoding: utf-8 -*-
require File.expand_path('../lib/oauth_multi_db/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dorren Chen"]
  gem.email         = ["dorrenchen@gmail.com"]
  gem.description   = %q{oauth client based db switching}
  gem.summary       = %q{switch db based on incoming oauth client}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "oauth_multi_db"
  gem.require_paths = ["lib"]
  gem.version       = OauthMultiDb::VERSION

  gem.add_dependency "rails"
  gem.add_dependency "rack-oauth2-server"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rspec-rails"
end
