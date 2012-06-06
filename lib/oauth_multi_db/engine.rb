require 'oauth_multi_db/action_controller'

module OauthMultiDb
  class Engine < Rails::Engine
    config.after_initialize do
      ActionController::Base.send :include, OauthMultiDb::ActionController
    end
  end
end
