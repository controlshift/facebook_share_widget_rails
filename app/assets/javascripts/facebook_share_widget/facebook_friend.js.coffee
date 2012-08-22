#= require underscore.js
#= require backbone.js
#= require handlebars-runtime.js

$ ->
  class FacebookFriend extends Backbone.Model
    url: '/widget/facebook/share'

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
      data.message = @messageModel.content()
      @startSharing()
      $.ajax
        url: @url
        type: "post"
        data: { post: data }
        success: (resp) =>
          friend.shared()
          friend.success_callback(friend)
        error: (jqXHR, textStatus, errorThrown) =>
          json = $.parseJSON(jqXHR.responseText)
          friend.shareFailedBecause(json.message)
          friend.fail_callback(friend)

    setMessageModel: (model) ->
      @messageModel = model

  app.models.FacebookFriend = FacebookFriend