class FacebookShareWidget::FacebookController < FacebookShareWidget::ApplicationController
  include FacebookShareWidget::FacebookHelper
  
  before_filter :sanitize_params, :except => [:share]

  def index
  end
  
  def personal_data
    begin
      @personal_data_results = my_personal_data @personal_data_type
      if @personal_data_results.empty?
        render :no_personal_data
      end
    rescue NotLoggedInException => ex
      render json: { message: "You are probably not logged in" }, status: :unauthorized
    rescue Exception => global_ex
      render json: { message: "Error has occured : #{global_ex.message}" }, status: :not_found
    end
  end

  def friends_personal_data
    begin
      @personal_data_results = fb_friends_personal_data @personal_data_type
      if @personal_data_results.empty?
        render :no_friends_personal_data
      end
    rescue NotLoggedInException => ex
      render json: { message: "You are probably not logged in" }, status: :unauthorized
    rescue Exception => global_ex
      render json: { message: "Error has occured : #{global_ex.message}" }, status: :not_found
    end
  end

  def friends
    begin
      render json: facebook_friends_for_link(params[:link], @personal_dataId, @personal_data_type), status: :ok
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

  def sanitize_params
    @personal_dataId = params[:personal_dataId] ? params[:personal_dataId].to_i : nil
    @personal_data_type = params[:personal_data_type].present? ? params[:personal_data_type].gsub('$','.') : nil
  end
  
  def log_exception_and_render_as_json(ex)
    Rails.logger.warn ex.message
    Rails.logger.warn ex.backtrace.join("\n")
    ExceptionNotifier::Notifier.background_exception_notification(ex) if defined? ExceptionNotifier
    render json: { message: "You've exceeded your daily facebook share limit." }, status: :internal_server_error
  end
end