#= require underscore.js
#= require backbone.js
#= require handlebars-runtime.js

$ ->
  class FaceBookFriend extends Backbone.Model

  class FaceBookFriends extends Backbone.Collection



  class FaceBookFriendView extends Backbone.View
    initialize: ->
      this.render()

    render: ->
      collection = new FaceBookFriends

      this.$el.html(HandlebarsTemplates['facebook_share_widget/templates/all_friends']())

  if $('#container').length
    new FaceBookFriendView(el: $('#container')  )
