$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "facebook_share_widget/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "facebook_share_widget"
  s.version     = FacebookShareWidget::VERSION
  s.authors     = ["Sean Ho"]
  s.email       = ["sean.ho@thoughtworks.com"]
  s.homepage    = "TODO"
  s.summary     = "Facebook Share Widget."
  s.description = "Facebook Share Widget."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "fb_graph"
  s.add_dependency "haml-rails"
  s.add_dependency "sass-rails"
  s.add_dependency "coffee-rails"
  s.add_dependency "compass-rails"

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
end
