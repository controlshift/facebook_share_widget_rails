$:.push File.expand_path("../lib", __FILE__)

require "facebook_share_widget/version"

Gem::Specification.new do |s|
  s.name        = "facebook_share_widget"
  s.version     = FacebookShareWidget::VERSION
  s.authors     = ["Sean Ho"]
  s.email       = ["sean.ho@thoughtworks.com"]
  s.homepage    = "https://github.com/seanhotw/facebook_share_widget_rails"
  s.summary     = "Facebook Share Widget."
  s.description = "Facebook Share Widget."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]

  s.add_dependency "fb_graph"
  s.add_dependency "haml-rails"
  s.add_dependency "sass-rails"
  s.add_dependency "coffee-rails"
  s.add_dependency "compass-rails"

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'guard-rspec'
end
