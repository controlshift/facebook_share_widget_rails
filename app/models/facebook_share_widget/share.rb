module FacebookShareWidget
  class Share < ActiveRecord::Base
    validates :user_facebook_id, presence: true
    validates :friend_facebook_id, presence: true
    validates :url, presence: true, uniqueness: {scope: [:user_facebook_id, :friend_facebook_id]}
    
    attr_accessible :user_facebook_id, :friend_facebook_id, :url, :message
    
  end
end
