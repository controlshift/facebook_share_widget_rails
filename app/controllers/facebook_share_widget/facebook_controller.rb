class FacebookShareWidget::FacebookController < FacebookShareWidget::ApplicationController
  include FacebookShareWidget::FacebookHelper
  
  def index
  end
  
  def friends
    begin
      render json: facebook_friends, status: :ok
    rescue Exception => ex
      log_exception_and_render_as_json(ex)
    end
  end
  
  def share
    begin
      post(params[:post])
      render json: {}, status: :ok
    rescue Exception => ex
      log_exception_and_render_as_json(ex)
    end
  end
  
  private
  
  def log_exception_and_render_as_json(ex)
    Rails.logger.warn ex.message
    Rails.logger.warn ex.backtrace.join("\n")
    ExceptionNotifier::Notifier.background_exception_notification(ex) if defined? ExceptionNotifier 
    render json: { message: ex.message }, status: :internal_server_error
  end
end