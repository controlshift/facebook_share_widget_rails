class FacebookShareWidget::FacebookController < FacebookShareWidget::ApplicationController
  include FacebookShareWidget::FacebookHelper
  
  def index
  end
  
  def employers
    begin
      @employers = my_employers
    rescue Exception => ex
      render json: { message: "You are probably not logged in" }, status: :not_found
    end
  end

  def friends
    begin
      render json: facebook_friends_for_link(params[:link]), status: :ok
    rescue Exception => ex
      log_exception_and_render_as_json(ex)
    end
  end
  
  def share
    begin
      me = facebook_me.fetch
      post(params[:post])
      share = FacebookShareWidget::Share.new(user_facebook_id: me.identifier, friend_facebook_id: params[:post][:facebook_id], url: params[:post][:link], message: params[:post][:message])
      share.save!
        
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
    render json: { message: "You've exceeded your daily facebook share limit." }, status: :internal_server_error
  end
end