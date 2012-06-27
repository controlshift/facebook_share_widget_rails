module FacebookShareWidget
  module ApplicationHelper
    def facebook_share_widget_helper
      output = render partial: "/facebook_share_widget/facebook/widget"
      output
    end
  end
end
