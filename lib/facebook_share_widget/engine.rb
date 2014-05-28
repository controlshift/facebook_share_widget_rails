require_relative '../../app/actions/facebook_share_widget/application_action'
require_relative '../../app/actions/facebook_share_widget/load_fb_data'
require_relative '../../app/actions/facebook_share_widget/friends'
require_relative '../../app/actions/facebook_share_widget/friends_personal_data'
require_relative '../../app/actions/facebook_share_widget/personal_data'

module FacebookShareWidget
  class Engine < ::Rails::Engine
    isolate_namespace FacebookShareWidget

    initializer "facebook_share_widget.assets.precompile" do |app|
      app.config.assets.compress = false
    end

  end
end
