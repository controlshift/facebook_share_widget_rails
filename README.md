# Facebook Share Widget - Rails Plugin

This project rocks.

## Installation

Add the gem to your Gemfile

```ruby
gem 'facebook_share_widget', :git => 'https://github.com/controlshift/facebook_share_widget_rails.git'
```

The widget requires Facebook access token to work and the token could be provided in 2 ways:

1. Facebook JS SDK integration

In your own application, create a initializer and provide the Facebook app ID and secret. The widget will then get the access token from the cookies automatically.

```ruby
FacebookShareWidget.client_id = "client_id"
FacebookShareWidget.client_secret = "client_secret"
```

2. Manually specifying token in session

In your own application, create a initializer and provide the session key that contains the access token. The widget will then get the access token from the session

```ruby
FacebookShareWidget.access_token_session_key = :facebook_access_token
```

## Usage

Mount the plugin in routes.rb

```ruby
mount FacebookShareWidget::Engine => "/widget"
```

On the page that embeds the widget

Add javascript and stylesheet to the head

```ruby
= stylesheet_link_tag "facebook_share_widget/application"
= javascript_include_tag "facebook_share_widget/application"
```
  
Render the widget in the body

```ruby
= render "/facebook_share_widget/facebook/widget"
```