#= require underscore.js
#= require backbone.js
#= require handlebars-runtime.js

$ ->
  class FacebookFriend extends Backbone.Model

  class FacebookFriends extends Backbone.Collection
    url: '/widget/facebook/friends'
    model: FacebookFriend

  class FacebookFriendView extends Backbone.View
    tagName: 'li'

    initialize: ->
      @model.on('change', @render, this)

    render: ->
      friend = @model.toJSON()
      $(@el).html(HandlebarsTemplates['facebook_share_widget/templates/friend'](friend))
      if friend.status == 'loaded'
        @renderLoaded()
      else
        @renderButton(friend)
      this

    renderLoaded: ->
      $(@el).append("<div class='indicator'><img src='/assets/facebook_share_widget/tick.png'/> Shared</div>")
      this

    renderButton: (friend) ->
      $(@el).append("<a class='share-button' data-facebook-id='#{friend.id}'>Share</a>")
      this


  class FacebookFriendsView extends Backbone.View
    initialize: ->
      @collection = new FacebookFriends
      @collection.on('reset', @render, this)
      @collection.fetch({ data: $.param({ link: "http://127.0.0.1:3000/petitions/campaign-test"})  })

    render: ->
      this.$el.html(HandlebarsTemplates['facebook_share_widget/templates/all_friends']())
      @collection.each(@appendFriend)

    appendFriend: (friend) ->
      friendView = new FacebookFriendView(model: friend)
      @$('#friends').append(friendView.render().el)

  if $('#container').length
    new FacebookFriendsView(el: $('#container'))
