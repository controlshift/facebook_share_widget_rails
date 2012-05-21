require 'spec_helper'

class DummyController
  include FacebookShareWidget::FacebookHelper
  
  attr_accessor :cookies, :session
  
  def initialize
    @cookies = Object.new
    @session = {}
  end
end

describe FacebookShareWidget::FacebookHelper do
  subject { DummyController.new }
  
  describe "#facebook_access_token" do
    it "should use client id and client secret to get token" do
      FacebookShareWidget.client_id = "client_id"
      FacebookShareWidget.client_secret = "client_secret"
      
      auth = mock
      FbGraph::Auth.stub(:new).with("client_id", "client_secret") { auth }
      auth.stub(:from_cookie).with(subject.cookies)
      auth.should_receive(:access_token) { "token" }
      
      subject.facebook_access_token.should == "token"
    end
    
    it "should use access token in session" do
      FacebookShareWidget.access_token_session_key = :facebook_access_token
      subject.session[:facebook_access_token] = "token"
      
      subject.facebook_access_token.should == "token"
    end
  end
  
  context "with valid access token" do
    before :each do
      @token = "token"
      subject.stub(:facebook_access_token) { @token }
    end
    
    describe "#facebook_me" do
      it "should get facebook me object" do
        me = mock
        FbGraph::User.should_receive(:me).with(@token) { me }
        subject.facebook_me.should == me
      end
    end
    
    describe "#facebook_user" do
      it "should get facebook user object" do
        user = mock
        FbGraph::User.stub(:new).with("12345", access_token: @token) { user }
        subject.facebook_user("12345").should == user
      end
    end
    
    describe "#facebook_friends" do
      it "should get facebook friend list" do
        raw_friends = [OpenStruct.new({ identifier: "1", name: "name" })]
        me = mock
        me.stub(:friends) { raw_friends }
        subject.stub(:facebook_me) { me }
        
        subject.facebook_friends.should == [{ id: "1", name: "name" }]
      end
    end
    
    describe "#post" do
      it "should post to user wall" do
        user = mock
        user.should_receive(:feed!).with({ message: "message" })
        subject.should_receive(:facebook_user).with("12345") { user }

        subject.post({ facebook_id: "12345", message: "message" })
      end
    end
  end
end