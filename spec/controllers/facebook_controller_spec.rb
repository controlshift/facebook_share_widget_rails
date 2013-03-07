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
      controller.should_receive(:facebook_friends_for_link).with('http://google.com/', nil, nil) { friends }

      get :friends, link: 'http://google.com/'
      
      response.should be_successful
      response.body.should == friends.to_json
    end

    it "should return friend list with CompId" do
      friends = [{ id: "1", name: "test"}]
      controller.should_receive(:facebook_friends_for_link).with('http://google.com/', 1234, 'a.test') { friends }

      get :friends, link: 'http://google.com/', personal_dataId: 1234, personal_data_type: 'a$test'
      
      response.should be_successful
      response.body.should == friends.to_json
    end
    
    it "should return error message on fail" do
      error = Exception.new("some error")
      controller.should_receive(:facebook_friends_for_link).with(anything(), anything(), anything()).and_raise(error)
      
      get :friends
      
      response.should_not be_successful
      response.body.should == { message: user_prompt }.to_json
    end
  end
  describe "#employers" do
    it "should return employers list" do
      employers = [{ id: "1", name: "Thoughtworks" }]
      controller.should_receive(:my_personal_data).with('work.employer') { employers }

      get :personal_data, personal_data_type: 'work$employer'
      
      response.should be_successful
      response.should render_template "facebook_share_widget/facebook/personal_data"
      assigns(:personal_data_results).to_json.should == employers.to_json
    end
    
    it "should return error message on fail" do
      error = Exception.new("some error")
      controller.should_receive(:my_personal_data).with('work.employer').and_raise(error)
      
      get :personal_data, personal_data_type: 'work$employer'
      
      response.should_not be_successful
      response.body.should == { message: "You are probably not logged in" }.to_json
    end

    it "should return no employers message when no employers are listed" do
      employers = []
      controller.should_receive(:my_personal_data).with('work.employer') { employers }

      get :personal_data, personal_data_type: 'work$employer'
      
      response.should be_successful
      response.should render_template "facebook_share_widget/facebook/no_personal_data"
    end
  end
  describe "#share" do
    context "successful post" do
      before(:each) do
        post_attrs = {'facebook_id' => '1', 'link' => 'http://www.communityrun.org/', 'post_id' => '1234'}
        controller.should_receive(:message_for).with('1234').and_return('test message')

        me = mock()
        me.should_receive(:fetch).and_return(fetch = mock())
        fetch.should_receive(:identifier).and_return(1)
        controller.should_receive(:facebook_me).and_return(me)

        post :share, post_attrs
      end

      
      specify { response.should be_successful }
      specify { FacebookShareWidget::Share.count == 1}
    end
    
    it "should return error message on fail" do
      error = Exception.new("some error")
      controller.should_receive(:message_for).with('1234').and_raise(error)
      me = mock()
      me.should_receive(:fetch).and_return(fetch = mock(identifier: 1))
      controller.should_receive(:facebook_me).and_return(me)
      
      post :share, post_id: '1234'
      
      response.should_not be_successful
      response.body.should == { message: user_prompt }.to_json
    end
  end

  describe "#change employer" do
    it "should return atmost top five employers list" do
      employers = [{ id: "1", name: "Thoughtworks" }, {id: "2", name: "ControlShift"}]
      controller.should_receive(:fb_friends_personal_data).with('work.employer') { employers }

      get :friends_personal_data, personal_data_type: 'work$employer'
      
      response.should be_successful
      response.should render_template "facebook_share_widget/facebook/friends_personal_data"
      assigns(:personal_data_results).to_json.should == employers.to_json
    end

    it "should return no employers message when no friends' employers are found" do
      employers = []
      controller.should_receive(:fb_friends_personal_data).with('work.employer') { employers }

      get :friends_personal_data, personal_data_type: 'work$employer'
      
      response.should be_successful
      response.should render_template "facebook_share_widget/facebook/no_friends_personal_data"
    end
  end
end