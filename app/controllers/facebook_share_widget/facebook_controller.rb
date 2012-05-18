class FacebookShareWidget::FacebookController < ::ApplicationController
  include FacebookShareWidget::FacebookHelpers
  
  def index
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