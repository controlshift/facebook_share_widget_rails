require 'not_logged_in_exception'
module FacebookShareWidget
  module FacebookHelper
    def facebook_access_token
      raise ::NotLoggedInException if FacebookShareWidget.client_id.blank? and session[FacebookShareWidget.access_token_session_key].blank?
      if FacebookShareWidget.access_token_session_key && session[FacebookShareWidget.access_token_session_key]
        session[FacebookShareWidget.access_token_session_key]
      else
        auth = FbGraph::Auth.new(FacebookShareWidget.client_id, FacebookShareWidget.client_secret)
        auth.from_cookie(cookies)
        auth.access_token
      end
    end
  
    def facebook_me
      FbGraph::User.me(self.facebook_access_token)
    end
  
    def facebook_user(facebook_id)
      FbGraph::User.new(facebook_id, access_token: self.facebook_access_token)
    end
  
    def my_personal_data(personal_data_type)
      Rails.cache.fetch("#{personal_data_type}_of_#{self.facebook_access_token}", :expires_in => 24.hours) do
        FacebookShareWidget::PersonalData.new(facebook_access_token: self.facebook_access_token, personal_data_type: personal_data_type).retrieve
      end
    end

    def fb_friends_personal_data(personal_data_type)
      Rails.cache.fetch("friends_for_#{self.facebook_access_token}_of_#{personal_data_type}", :expires_in => 1.hour) do
        FacebookShareWidget::FriendsPersonalData.new(facebook_access_token: self.facebook_access_token, personal_data_type: personal_data_type).retrieve
      end
    end

    def facebook_friends(personal_data_id, personal_data_type)
      Rails.cache.fetch("friends_for_#{self.facebook_access_token}_for_#{personal_data_type}_as_#{personal_data_id}", :expires_in => 1.hour) do
        FacebookShareWidget::Friends.new(facebook_access_token: self.facebook_access_token, personal_data_type: personal_data_type, personal_data_id: personal_data_id).retrieve
      end
    end
    
    def facebook_friends_for_link(url, personal_dataId, personal_data_type)
      friends = append_shares_loaded(facebook_friends(personal_dataId, personal_data_type), url)
      friends.collect {|key, value| value }
    end
    
    def append_shares_loaded(friends, url)
      me = facebook_me.fetch
      shares = FacebookShareWidget::Share.all conditions: {url: url, user_facebook_id: "#{me.identifier}"}
      shares.each do | share |
        friends[share.friend_facebook_id] = friends[share.friend_facebook_id].merge({:status => 'shared'}) if friends[share.friend_facebook_id]
      end
      friends
    end
    
    def message_for post_id
      FbGraph::Post.new(post_id).fetch(:access_token => self.facebook_access_token).message
    end
  end
end