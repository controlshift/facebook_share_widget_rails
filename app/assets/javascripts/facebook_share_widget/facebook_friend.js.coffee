#= require underscore.js
#= require backbone.js
#= require handlebars.js

$ ->
  class FacebookFriend extends Backbone.Model
    url: 'https://www.facebook.com/dialog/feed?app_id={app_id}&link={link}&to={to}&redirect_uri={redirect_uri}'

    constructor: ->
      Backbone.Model.apply(this, arguments)
      @options = arguments[0] ? {}
      @success_callback = @options.success_callback ? window.facebookShareWidget.callbacks.success
      @fail_callback = @options.fail_callback ? window.facebookShareWidget.callbacks.fail

    isShared: ->
      @get('status') == 'shared'

    shared: ->
      @set('status': 'shared')

    isSharing: ->
      @get('status') == 'sharing'

    startSharing: ->
      @set('status': 'sharing')

    shareFailedBecause: (reason)->
      @set('status': 'failed', 'reason': reason)

    isShareFailed: ->
      @get('status') == 'failed'

    share: (template) ->
      friend = this
      data = $.extend({}, $.parseJSON(template))
      data.facebook_id = @id
      redirect_uri = window.location.protocol + '//' + window.location.host + '/widget/facebook/share-redirect?facebook_id='+data.facebook_id+'&link='+data.link

      FB.ui { method: 'feed', link: data.link, redirect_uri: redirect_uri, to: data.facebook_id }, (response)->
        if response && response.post_id
          $.get redirect_uri, post_id: response.post_id, ->
            friend.shared()
            friend.success_callback(friend)

    setMessageModel: (model) ->
      @messageModel = model

  app.models.FacebookFriend = FacebookFriend