class OauthIssuersController < ApplicationController
  #oauth_required :only => [:create, :destroy]

  def index
    issuers = Rack::OAuth2::Server::Issuer.collection.find.entries
    render :json => issuers.to_json
  end

  def show
    issuer = Rack::OAuth2::Server.get_issuer(params[:id])

    if issuer
      render :json => issuer.to_json
    else
      render :nothing => true, :status => :not_found
    end
  end

  def create
    attrs = {:identifier  => params[:issuer_id],
             :hmac_secret => params[:issuer_secret]}

    issuer = Rack::OAuth2::Server.register_issuer(attrs)
    render :json => issuer.to_json
  end

  def destroy
    issuer = Rack::OAuth2::Server.get_issuer(params[:id])

    if issuer
      issuer.destroy
      render :nothing => true, :status => :ok
    else
      render :nothing => true, :status => :not_found
    end
  end
end


