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
      $(@el).html(HandlebarsTemplates['facebook_share_widget/templates/friend'](@model.toJSON()))
      this

  class FacebookFriendsView extends Backbone.View
    initialize: ->
      @collection = new FacebookFriends
      @collection.on('reset', @render, this)
      @collection.fetch()

    render: ->
      this.$el.html(HandlebarsTemplates['facebook_share_widget/templates/all_friends']())
      @collection.each(@appendFriend)

    appendFriend: (friend) ->
      friendView = new FacebookFriendView(model: friend)
      @$('#friends').append(friendView.render().el)



  if $('#container').length
    new FacebookFriendsView(el: $('#container'))
