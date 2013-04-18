describe "FacebookFriend ", ->

  beforeEach ->
    $.get = (url, data, callback) ->
      callback()
    window.HandlebarsTemplates = {}
    window.HandlebarsTemplates['facebook_share_widget/templates/friend'] = (f) ->
    setFixtures('<div id="sandbox"><div class="loader tick"><img src=""/></div></div>')
    window.FB = {};
    window.FB.ui = (data, callback) ->
      callback({post_id: 123})
    window.FB.init = ->
    
  it "should share message to friend", ->

    facebookFriend = new app.models.FacebookFriend
    facebookFriendView = new app.views.FacebookFriendView(model: facebookFriend, el: $('#sandbox'))
    facebookFriendView.render()

    $('.share-button').click()

    expect(facebookFriend.isShared()).toBe(true)

  it "should share message with default callback from window.facebookShareWidget", ->
    @success_callback = (friend) ->
    spyOn(this, 'success_callback')

    window.facebookShareWidget.callbacks.success = @success_callback

    facebookFriend = new app.models.FacebookFriend
    facebookFriendView = new app.views.FacebookFriendView(model: facebookFriend, el: $('#sandbox'))
    facebookFriendView.render()

    $('.share-button').click()

    expect(@success_callback).toHaveBeenCalledWith(facebookFriend);

  it "should share message with callback", ->
    @success_callback = (friend) ->
    spyOn(this, 'success_callback')

    facebookFriend = new app.models.FacebookFriend success_callback: @success_callback
    facebookFriendView = new app.views.FacebookFriendView(model: facebookFriend, el: $('#sandbox'))
    facebookFriendView.render()

    $('.share-button').click()

    expect(@success_callback).toHaveBeenCalledWith(facebookFriend);

  it "should call FB.ui function with redirect_uri and proper data", ->
    window.FB.ui = (data, callback) ->
      expect(data.method).toEqual('feed')
      expect(data.to).toEqual(123)
      expect(data.redirect_uri).toMatch("facebook_id=123")
      expect(data.redirect_uri).toMatch("link=test")
      expect(data.redirect_uri).toMatch("facebook/share-redirect")

    facebookFriend = new app.models.FacebookFriend(id: 123)
    facebookFriendView = new app.views.FacebookFriendView(model: facebookFriend, el: $('#sandbox'))
    spyOn(facebookFriendView,'sharingTemplate').andCallFake ->
      '{"link":"test"}'
    facebookFriendView.render()

    $('.share-button').click()


