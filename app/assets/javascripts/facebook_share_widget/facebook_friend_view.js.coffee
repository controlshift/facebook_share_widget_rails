#= require underscore.js
#= require backbone.js
#= require handlebars.js

$ ->
  class FacebookFriendView extends Backbone.View
    tagName: 'li'
    events:
      'click .share-button': 'shareToFriend'

    initialize: ->
      @model.on('change', @render, this)

    render: ->
      friend = @model.toJSON()
      $(@el).html(HandlebarsTemplates['facebook_share_widget/templates/friend'](friend))
      if @model.isShared()
        @renderShared()
      else if @model.isSharing()
        @renderSharing()
      else if @model.isShareFailed()
        @renderFailed(friend)
      else
        @renderToShare(friend)
      this

    renderShared: ->
      $(@el).append("<div class='indicator'><img src='#{$('.tick img').attr('src')}'/> Shared</div>")
      this

    renderSharing: ->
      $(@el).append("<div class='indicator'><img src='#{$('.loader img').attr('src')}'/> Sharing</div>")
      this

    renderToShare: (friend) ->
      $(@el).append("<a class='share-button' data-facebook-id='#{friend.id}'>Share</a>")
      this

    renderFailed: (friend) ->
      $(@el).children('.error-message').text(friend.reason)
      this

    shareToFriend: (event) ->
      event.preventDefault()
      @model.share(@sharingTemplate())

    sharingTemplate: ->
      $('.template').text()

  app.views.FacebookFriendView = FacebookFriendView