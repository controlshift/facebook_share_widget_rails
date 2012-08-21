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

  it "should share message with callback", ->








