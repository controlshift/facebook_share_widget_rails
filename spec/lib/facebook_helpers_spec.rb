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
    
    describe "#facebook_friends_for_link" do
      
      before(:each) do
        FacebookShareWidget::Share.create!(friend_facebook_id: 1, user_facebook_id: 2, url: 'http://www.google.com/' )
      end
      
      it "should get the friends" do
        raw_friends = [OpenStruct.new({ identifier: "1", name: "name" })]        
        subject.should_receive(:facebook_friends).with(anything(), anything()).and_return(raw_friends)
        subject.should_receive(:append_shares_loaded).with(raw_friends, 'http://www.google.com/').and_return(raw_friends)
        
        subject.facebook_friends_for_link('http://www.google.com/',123,123)
      end
      
      it "should append the status" do
        me = mock()
        me.should_receive(:fetch).and_return(me)
        me.should_receive(:identifier).and_return(2)
        
        FbGraph::User.should_receive(:me).with(@token) { me }
        friends = {"1" => { id: "1", name: "name" }, "2" => { id: "2", name: "name2" }}

        with_appends = subject.append_shares_loaded(friends, 'http://www.google.com/')
        with_appends.should == { "1" => { status: 'shared', id: "1", name: "name" }, "2" => { id: "2", name: "name2" }}
      end
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
        
        subject.facebook_friends(nil, nil).should == {"1" => { id: "1", name: "name" }}
      end
    end

    describe "#facebook_friends" do
      it "should get facebook friend list if compId is specified" do
        raw_friends = [{ uid: "1", name: "name" ,work: [{employer: {id: 123}}]}]
        FbGraph::Query.any_instance.stub(:fetch).with(anything()).and_return(raw_friends)
        subject.stub(:facebook_access_token).and_return('test')
        subject.facebook_friends(123,"work.employer").should == {"1" => { id: "1", name: "name" }}
      end
    end
    
    describe "#my_personal_data" do
      it "should return back list of my employers" do
        raw_employers = [{ uid: "1", name: "name" , work: [{employer: {id: "123", 
        name: "Senior Consultant"}, start_date: "2012-03"}] }]
        FbGraph::Query.any_instance.stub(:fetch).with(anything()).and_return(raw_employers)
        
        subject.my_personal_data('work.employer').should == [{ id: "123", name: "Senior Consultant" }]
      end
    end

    describe "#friends_employers" do
      it "should return back list of top five friends employers" do
        raw_friends = [{ uid: "1", name: "name1" ,work: [{employer: {id: 11, name: "name11"}}]},
                        { uid: "2", name: "name2" ,work: [{employer: {id: 22, name: "name22"}}]},
                        { uid: "3", name: "name3" ,work: [{employer: {id: 33, name: "name33"}}]},
                        { uid: "4", name: "name4" ,work: [{employer: {id: 44, name: "name44"}}]},
                        { uid: "5", name: "name5" ,work: [{employer: {id: 66, name: "name66"}}]},
                        { uid: "6", name: "name6" ,work: [{employer: {id: 55, name: "name55"}}]},
                        { uid: "7", name: "name7" ,work: [{employer: {id: 11, name: "name11"}}]},
                        { uid: "8", name: "name8" ,work: [{employer: {id: 66, name: "name66"}}]},
                        { uid: "9", name: "name9" ,work: [{employer: {id: 66, name: "name66"}}]}]
        FbGraph::Query.any_instance.stub(:fetch).with(anything()).and_return(raw_friends)
        subject.fb_friends_personal_data('work.employer').size.should == 5
      end
    end

    it {should respond_to :message_for}
  end
end