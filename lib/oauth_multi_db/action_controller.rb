require 'active_support/configurable'

# perform DB switch based on incoming oauth request's client_id
#
# For each request, if oauth client is found. it retrieves client.client_symbol value (from notes field), 
# and uses it to switch to corresponding db.
#
# To set client_symbol on Oauth2 client, do it when your register it:
#   Rack::OAuth2::Server.register(
#     :display_name => 'oauth client 1',
#     :notes => {'client_symbol' => 'abc'}.to_json
#   )
#
#
# Setup
# 1. create config/initializers/oauth_multi_db_config.rb, with code below:
#   require 'oauth_multi_db'
#
#   OauthMultiDb.configure do |config|
#     config.domain_models = [User, Article]    # models that will have db changed.
#
#     # your custom way to change db, or anything based on client_symbol
#     config.switcher = lambda {|client_symbol| 
#                         new_db = "db_" + client_symbol.to_s 
#                         # change to new db
#                       }
#   end
#
# 2. in your controller, use the macro
#   class ApplicationController
#     oauth_db_switch
#     # or
#     oauth_db_switch, :only => [:create, :update]   # or any before_filter options
#   end
# 
#
# This module requires rack-oauth2-server gem. see https://github.com/assaf/rack-oauth2-server for more info.
module OauthMultiDb
  module ActionController
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def oauth_db_switch(options={})
        before_filter :oauth_db_switch, options
      end
    end

    # switch db based on incoming oauth client_id
    def oauth_db_switch
      if client_symbol = get_client_symbol
        OauthMultiDb.config.db_switcher.call(client_symbol)
      end
    end

    def get_client_symbol
      if client = oauth.client
        client.parse_notes
        symbol = client.client_symbol
      end
    end
  end
end
