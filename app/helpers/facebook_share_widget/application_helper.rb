module FacebookShareWidget
  module ApplicationHelper
    def facebook_share_widget_helper(options = {})
      options[:template] = {} if options[:template].nil?
      options[:template][:link] = "http://#{request.host}:#{request.port.to_s+request.fullpath}" if options[:template][:link].blank?
      output = render partial: "/facebook_share_widget/facebook/widget", locals: { options: options }
      output
    end
  end
end
