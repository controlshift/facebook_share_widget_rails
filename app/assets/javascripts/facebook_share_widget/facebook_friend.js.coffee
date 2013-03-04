#= require underscore.js
#= require backbone.js
#= require handlebars-runtime.js

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

      window.open @url.replace('{app_id}', data.appId).replace('{to}', data.facebook_id).replace('{link}', encodeURIComponent(data.link)).replace('{redirect_uri}',encodeURIComponent(redirect_uri)), 'sharer', 'toolbar=0,status=0,width=1000,height=600'

      friend.shared()
      friend.success_callback(friend)
      
    setMessageModel: (model) ->
      @messageModel = model

  app.models.FacebookFriend = FacebookFriend