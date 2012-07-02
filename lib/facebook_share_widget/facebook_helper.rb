module FacebookShareWidget
  module FacebookHelper
    def facebook_access_token
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
  
    def facebook_friends
      Rails.cache.fetch("friends_for_#{self.facebook_access_token}", :expires_in => 1.hour) do
        friends = {}
        facebook_me.friends.each do|f|
          friends[f.identifier] = { id: f.identifier, name: f.name }
        end
        friends
      end
    end
    
    def facebook_friends_for_link(url)
      friends = append_shares_loaded(facebook_friends, url)      
      friends.collect {|key, value| value }
    end
    
    def append_shares_loaded(friends, url)
      me = facebook_me.fetch
      friends
      shares = FacebookShareWidget::Share.all conditions: {url: url, user_facebook_id: "#{me.identifier}"}
      shares.each do | share |
        friends[share.friend_facebook_id] = friends[share.friend_facebook_id].merge({:status => 'loaded'}) if friends[share.friend_facebook_id]
      end
      friends
    end
  
    def post(post = {})
      p = post.dup #fix pass by reference bug.
      facebook_id = p.delete(:facebook_id)
      facebook_user(facebook_id).feed!(p)
    end
  end
end