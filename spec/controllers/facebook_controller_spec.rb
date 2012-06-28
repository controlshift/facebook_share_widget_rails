require 'spec_helper'

describe FacebookShareWidget::FacebookController do
  describe "#index" do
    before :each do
      get :index
    end

    it { should render_template :index }
  end
  
  describe "#friends" do
    it "should return friend list" do
      friends = [{ id: "1", name: "test" }]
      controller.should_receive(:facebook_friends) { friends }

      get :friends
      
      response.should be_successful
      response.body.should == friends.to_json
    end
    
    it "should return error message on fail" do
      error = Exception.new("some error")
      controller.should_receive(:facebook_friends).and_raise(error)
      
      get :friends
      
      response.should_not be_successful
      response.body.should == { message: error.message }.to_json
    end
  end
  
  describe "#share" do
    context "successful post" do
      before(:each) do
        post_attrs = { "message" => "hi", 'facebook_id' => '1', 'link' => 'http://www.communityrun.org/' }
        controller.should_receive(:post).with(post_attrs)
        me = mock()
        me.should_receive(:identifier).and_return(1)
        controller.should_receive(:facebook_me).and_return(me)

        post :share, post: post_attrs     
      end

      
      specify { response.should be_successful }
      specify { FacebookShareWidget::Share.count }
    end
    
    it "should return error message on fail" do
      error = Exception.new("some error")
      controller.should_receive(:post).and_raise(error)
      
      post :share
      
      response.should_not be_successful
      response.body.should == { message: error.message }.to_json
    end
  end
end