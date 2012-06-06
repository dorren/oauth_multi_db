require 'active_support/configurable'

# perform Mongo DB switch based on incoming oauth request's client_id
#
# For each request, if oauth client is found. it retrieves client.client_symbol value (from notes field), 
# and uses it to switch to corresponding mongo db.
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
#     config.domain_models = [User, Article]    # mongoid models that will have db changed.
#
#     # your custom way to generate db name based on client_symbol
#     config.name_builder = lambda {|client_symbol| Mongoid.master.name + "_" + client_symbol.to_s }
#   end
#
# 2. in your controller, use the macro
#   class ApplicationController
#     oauth_db_switch
#     # or
#     oauth_db_swith, :only => [:create, :update]   # or any before_filter options
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
        db_name = OauthMultiDb.config.name_builder.call(client_symbol)
        switch_db(db_name)
      end
    end

    def get_client_symbol
      if client = oauth.client
        client.parse_notes
        symbol = client.client_symbol
      end
    end

    def switch_db(db_name)
      Mongoid::Config.add_database(db_name, {'database' => db_name})
      OauthMultiDb.config.domain_models.each do |model_class|
        if model_class.db.name != db_name
          model_class.set_database_n_clear_cache(db_name)
        end
      end
    end
  end
end
