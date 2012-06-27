module FacebookShareWidget
  module ApplicationHelper
    def facebook_share_widget_helper(options = {})
      options[:share_url] = "http://#{request.host}:#{request.port+request.fullpath}" if options[:share_url].blank?
      output = render partial: "/facebook_share_widget/facebook/widget", locals: {options: options}
      output
    end
  end
end
