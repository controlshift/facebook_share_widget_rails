# Facebook Share Widget - Rails Plugin

This project rocks.

![](http://f.cl.ly/items/1l2O1z3F141l1J473t1v/Screen%20Shot%202012-05-22%20at%2011.21.53%20AM.png)

## Installation

Add the gem to your Gemfile

```ruby
gem 'facebook_share_widget', :git => 'https://github.com/controlshift/facebook_share_widget_rails.git'
```

The widget requires Facebook access token to work and the token could be provided in 2 ways:

### Facebook JS SDK integration

Create an initializer in your own application and set the Facebook App ID and secret. The widget will then obtain the access token from the cookies automatically.

```ruby
FacebookShareWidget.client_id = "client_id"
FacebookShareWidget.client_secret = "client_secret"
```

### Manually specifying token in session

Create an initializer in your own application and set the session key that contains the access token. The widget will then obtain the access token from the session.

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