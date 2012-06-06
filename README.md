# OauthMultiDb

Switch mongo db based on incoming oauth client

## Installation

Add this line to your application's Gemfile:

    gem 'oauth_multi_db'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oauth_multi_db

## Usage

For each request, if oauth client is found. it retrieves client.client_symbol value (from notes field), 
and uses it to switch to corresponding mongo db.

To set client_symbol value on Oauth2 client, do it when your register it:
``` ruby
    Rack::OAuth2::Server.register(
      :display_name => 'oauth client 1',
      :notes => {'client_symbol' => 'abc'}.to_json
    )
```

Setup
1. In rails app, create config/initializers/oauth_multi_db_config.rb, with code below:
``` ruby
require 'oauth_multi_db'

OauthMultiDb.configure do |config|
  config.domain_models = [User, Article]    # mongoid models that will have db changed.

  # your custom way to generate db name based on client_symbol, must be a lambda or proc
  config.name_builder = lambda {|client_symbol| Mongoid.master.name + "_" + client_symbol.to_s }
end
```

2. in your controller, use the macro
``` ruby
class ApplicationController
  oauth_db_switch
  # or
  oauth_db_swith, :only => [:create, :update]   # or any before_filter options
end
```

This gem requires rack-oauth2-server gem. see https://github.com/assaf/rack-oauth2-server for more info.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
