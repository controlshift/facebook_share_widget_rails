require 'spec_helper'

describe FacebookShareWidget::Share do
  subject { FacebookShareWidget::Share.new }
  
  it { should validate_presence_of(:user_facebook_id) }
  it { should validate_presence_of(:friend_facebook_id) }
  it { should validate_presence_of(:url) }
  
  context "an object" do
    subject { FacebookShareWidget::Share.create(user_facebook_id: '1', friend_facebook_id: '2', url:'http://www.google.com/' )}
    it { should validate_uniqueness_of(:url).scoped_to([:user_facebook_id, :friend_facebook_id]) }
  end
end