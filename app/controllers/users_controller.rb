class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:destroy]

  def index
    if(current_user.email == 'matt8355@hotmail.com' or current_user.email == 'fuadcse@gmail.com')
      @users = User.registered
    else
      redirect_to root_url() and return
    end    
  end

  def destroy
    @user = User.find_by_id(params[:id])
    @user.authentications.delete_all()
    @user.destroy()
    reset_session()
    redirect_to root_url()
  end

  def message_form
    @user = User.find(params[:id])
    @provider = params[:provider]
    respond_to do |format|
      format.html
      format.js { render_to_facebox }
    end
  end

  def send_message
    user = User.find(params[:id])
    provider = params[:provider] == User::TYPE_PROVIDER_LINKEDIN ? 'linked_in' : params[:provider]
    authentication = current_user.authentications.find_by_provider(provider)
    if(params[:provider] == User::TYPE_PROVIDER_FACEBOOK)
      fb_user = FbGraph::User.new(user.provider_id, :access_token => authentication.token)
      response = fb_user.feed!(:message => params[:message_text])
    elsif(params[:provider] == User::TYPE_PROVIDER_LINKEDIN)
      keys = YAML.load_file("#{Rails.root}/config/keys.yml")
      linkedin_token = keys["linkedid_token"]
      linkedin_secret_key = keys["linkedin_secret_key"]
      client = LinkedIn::Client.new(linkedin_token, linkedin_secret_key)
      client.authorize_from_access(authentication.token,  authentication.secret)
      response = client.send_message(params[:message_subject], params[:message_text], user.provider_id)
    end

    respond_to do |format|
      format.html
      format.js { close_facebox }
    end

  end
end
