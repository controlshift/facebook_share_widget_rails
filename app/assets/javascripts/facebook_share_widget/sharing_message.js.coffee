$ ->
  class SharingMessage extends Backbone.Model
    content: ->
      @get('msg')
  app.models.SharingMessage = SharingMessage