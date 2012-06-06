class OauthClientsController < ApplicationController
  #oauth_required :only => [:create, :destroy]

  def index
    clients = Rack::OAuth2::Server::Client.all.collect{|x| x.parse_notes; x}
    render :json => clients.to_json
  end

  def show
    client = Rack::OAuth2::Server.get_client(params[:id])

    if client
      client.parse_notes
      render :json => client.to_json
    else
      render :nothing => true, :status => :not_found
    end
  end

  def create
    attrs = {:id           => params[:id],
             :secret       => params[:secret],
             :display_name => params[:display_name],
             :link         => params[:link]}

    client = Rack::OAuth2::Server.register(attrs)
    render :json => client.to_json
  end

  def destroy
    client = Rack::OAuth2::Server.get_client(params[:id])

    if client
      client.destroy
      render :nothing => true, :status => :accepted
    else
      render :nothing => true, :status => :not_found
    end
  end
end

