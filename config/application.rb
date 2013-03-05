module FacebookShareWidget
	class Application < Rails::Application
		config.assets.precompile += ['facebook_share_widget/facebook_friend_view.js']
	end
end