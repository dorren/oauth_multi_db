module OauthClientExt
  extend ActiveSupport::Concern

  included do
    attr_reader :client_symbol
  end

  module ClassMethods
  end

  def parse_notes
    hash = JSON.parse(self.notes) rescue {}
    @client_symbol = hash['client_symbol']
  end
end
