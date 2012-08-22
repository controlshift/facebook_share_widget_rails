describe "FacebookFriend ", ->

  beforeEach ->
    window.HandlebarsTemplates = {}
    window.HandlebarsTemplates['facebook_share_widget/templates/friend'] = (f) ->
    setFixtures('<div id="sandbox"><div class="loader tick"><img src=""/></div></div>')


  it "should share message to friend", ->

    spyOn($, "ajax").andCallFake (options)->
      options.success()
    facebookFriend = new app.models.FacebookFriend
    facebookFriend.setMessageModel(new app.models.SharingMessage( msg: 'msg'))
    facebookFriendView = new app.views.FacebookFriendView(model: facebookFriend, el: $('#sandbox'))
    facebookFriendView.render()

    $('.share-button').click()

    expect(facebookFriend.isShared()).toBe(true)

  it "should share message with default callback from window.facebookShareWidget", ->
    spyOn($, "ajax").andCallFake (options)->
      options.success()
    @success_callback = (friend) ->
    spyOn(this, 'success_callback')

    window.facebookShareWidget.callbacks.success = @success_callback

    facebookFriend = new app.models.FacebookFriend
    facebookFriend.setMessageModel(new app.models.SharingMessage( msg: 'msg'))
    facebookFriendView = new app.views.FacebookFriendView(model: facebookFriend, el: $('#sandbox'))
    facebookFriendView.render()

    $('.share-button').click()

    expect(@success_callback).toHaveBeenCalledWith(facebookFriend);

  it "should share message with callback", ->
    spyOn($, "ajax").andCallFake (options)->
      options.success()
    @success_callback = (friend) ->
    spyOn(this, 'success_callback')

    facebookFriend = new app.models.FacebookFriend success_callback: @success_callback
    facebookFriend.setMessageModel(new app.models.SharingMessage( msg: 'msg'))
    facebookFriendView = new app.views.FacebookFriendView(model: facebookFriend, el: $('#sandbox'))
    facebookFriendView.render()

    $('.share-button').click()

    expect(@success_callback).toHaveBeenCalledWith(facebookFriend);

  it "should report error", ->
    spyOn($, "ajax").andCallFake (options)->
      options.error({responseText: '{"message":"111"}'})

    facebookFriend = new app.models.FacebookFriend
    facebookFriend.setMessageModel(new app.models.SharingMessage( msg: 'msg'))
    facebookFriendView = new app.views.FacebookFriendView(model: facebookFriend, el: $('#sandbox'))
    facebookFriendView.render()

    $('.share-button').click()

    expect(facebookFriend.isShareFailed()).toBe(true)
    expect(facebookFriend.get('reason')).toBe("111")

  it "should share message with callback when error happening", ->
    spyOn($, "ajax").andCallFake (options)->
      options.error({responseText: '{"message":"111"}'})
    @error_callback = (friend) ->
    spyOn(this, 'error_callback')

    facebookFriend = new app.models.FacebookFriend fail_callback: @error_callback
    facebookFriend.setMessageModel(new app.models.SharingMessage( msg: 'msg'))
    facebookFriendView = new app.views.FacebookFriendView(model: facebookFriend, el: $('#sandbox'))
    facebookFriendView.render()

    $('.share-button').click()

    expect(@error_callback).toHaveBeenCalledWith(facebookFriend);








