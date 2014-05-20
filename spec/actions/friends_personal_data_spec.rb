require 'spec_helper'

describe FacebookShareWidget::FriendsPersonalData do
  describe 'initialization' do
    let(:facebook_access_token) { 'fb_access_token' }
    let(:personal_data_type) { 'personal_data_type' }
    subject { FacebookShareWidget::FriendsPersonalData.new(facebook_access_token: facebook_access_token, personal_data_type: personal_data_type) }

    it 'should allow for initialization' do
      subject.personal_data_type.should == personal_data_type
      subject.facebook_access_token.should == facebook_access_token
    end
  end
end