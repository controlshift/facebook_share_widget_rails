class FacebookShareWidget::FacebookController < FacebookShareWidget::ApplicationController
  include FacebookShareWidget::FacebookHelper
  
  def index
    session[:facebook_access_token] = "AAACEdEose0cBAB1yrvStSQR5pKimn7zjqg6nUDUpyOVKcyZBZCgvMU2AVBuq4CalgZBZCSE5G74ZARfZCuIivAlCOMgBYtj6eq9DirxmCBawZDZD"
  end
  
  def friends
    begin
      render json: facebook_friends, status: :ok
    rescue Exception => ex
      render json: { message: ex.message }, status: :internal_server_error
    end
  end
  
  def share
    begin
      post(params[:post])
      render json: {}, status: :ok
    rescue Exception => ex
      render json: { message: ex.message }, status: :internal_server_error
    end
  end
end