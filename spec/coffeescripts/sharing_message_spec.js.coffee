describe "SharingMessage ", ->

  it "should get empty msg by default", ->
    sharingMessage = new app.models.SharingMessage
    expect(sharingMessage.content()).toBe('')