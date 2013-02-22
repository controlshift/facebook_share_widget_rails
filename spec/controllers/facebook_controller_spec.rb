require 'spec_helper'

describe FacebookShareWidget::FacebookController do

  let(:user_prompt) { "You've exceeded your daily facebook share limit." }

  describe "#index" do
    before :each do
      get :index
    end

    it { should render_template :index }
  end
  
  describe "#friends" do
    it "should return friend list" do
      friends = [{ id: "1", name: "test"}]
      controller.should_receive(:facebook_friends_for_link).with('http://google.com/', nil) { friends }

      get :friends, link: 'http://google.com/'
      
      response.should be_successful
      response.body.should == friends.to_json
    end

    it "should return friend list" do
      friends = [{ id: "1", name: "test"}]
      controller.should_receive(:facebook_friends_for_link).with('http://google.com/', 1234) { friends }

      get :friends, link: 'http://google.com/', compId: 1234
      
      response.should be_successful
      response.body.should == friends.to_json
    end
    
    it "should return error message on fail" do
      error = Exception.new("some error")
      controller.should_receive(:facebook_friends_for_link).with(anything(), anything()).and_raise(error)
      
      get :friends
      
      response.should_not be_successful
      response.body.should == { message: user_prompt }.to_json
    end
  end
  describe "#employers" do
    it "should return employers list" do
      employers = [{ id: "1", name: "Thoughtworks" }]
      controller.should_receive(:my_employers) { employers }

      get :employers
      
      response.should be_successful
      assigns(:employers).to_json.should == employers.to_json
    end
    
    it "should return error message on fail" do
      error = Exception.new("some error")
      controller.should_receive(:my_employers).and_raise(error)
      
      get :employers
      
      response.should_not be_successful
      response.body.should == { message: "You are probably not logged in" }.to_json
    end
  end
  describe "#share" do
    context "successful post" do
      before(:each) do
        post_attrs = { "name"=>"name of page", "message" => "hi", 'facebook_id' => '1', 'link' => 'http://www.communityrun.org/' }
        controller.should_receive(:post).with(post_attrs)

        me = mock()
        me.should_receive(:fetch).and_return(fetch = mock())
        fetch.should_receive(:identifier).and_return(1)
        controller.should_receive(:facebook_me).and_return(me)

        post :share, post: post_attrs     
      end

      
      specify { response.should be_successful }
      specify { FacebookShareWidget::Share.count == 1}
    end
    
    it "should return error message on fail" do
      error = Exception.new("some error")
      controller.should_receive(:post).and_raise(error)
      me = mock()
      me.should_receive(:fetch).and_return(fetch = mock())
      controller.should_receive(:facebook_me).and_return(me)
      
      post :share
      
      response.should_not be_successful
      response.body.should == { message: user_prompt }.to_json
    end
  end
end