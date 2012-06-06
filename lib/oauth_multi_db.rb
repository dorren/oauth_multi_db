require "oauth_multi_db/version"
require "oauth_multi_db/oauth_client_ext"
require "oauth_multi_db/action_controller"
require "oauth_multi_db/engine"

module OauthMultiDb
  include ActiveSupport::Configurable
end
      
Rack::OAuth2::Server::Client.send :include, OauthClientExt
