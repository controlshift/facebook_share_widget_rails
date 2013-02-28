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

  def change_employer
    begin
      @employers = friends_employers
    rescue Exception => ex
      render json: { message: "You are probably not logged in" }, status: :not_found
    end
  end

  def friends
    begin
      render json: facebook_friends_for_link(params[:link], params[:compId] ? params[:compId].to_i : nil), status: :ok
    rescue Exception => ex
      log_exception_and_render_as_json(ex)
    end
  end
  
  def share
    begin
      if params[:post_id]
        me = facebook_me.fetch
        share = FacebookShareWidget::Share.new(user_facebook_id: me.identifier, friend_facebook_id: params[:facebook_id], url: params[:link], message: message_for(params[:post_id]))
        share.save!
      end
      render layout: false
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