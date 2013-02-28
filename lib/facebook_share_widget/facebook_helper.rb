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
  
    def my_employers
      Rails.cache.fetch("employers_of_#{self.facebook_access_token}", :expires_in => 24.hours) do
        employers = []
        facebook_me.fetch.work.each do |work_object| 
          employers << work_object.employer
        end
        employers
      end
    end

    def friends_employers
      Rails.cache.fetch("friends_for_#{self.facebook_access_token}", :expires_in => 1.hour) do
        employers = Hash.new(0)
        FbGraph::Query.new('select uid, name, work.employer from user where uid in (select uid2 from friend where uid1=me())').
        fetch(self.facebook_access_token).each do|f|
          employers[f[:work][0][:employer]] += 1 if !f[:work].empty?
        end
        Hash[employers.sort {|a,b| b[1]<=>a[1]}].keys[0..4]
      end
    end

    def facebook_friends(compId)
      Rails.cache.fetch("friends_for_#{self.facebook_access_token}_at_#{compId}", :expires_in => 1.hour) do
        friends = {}
        if(compId != nil)
          FbGraph::Query.new('select uid, name, work.employer.id from user where uid in (select uid2 from friend where uid1=me())').
          fetch(self.facebook_access_token).each do|f|
            if(f[:work].collect {|a| a[:employer]}.collect {|a| a[:id]}.include?(compId))
              friends[f[:uid]] = { id: f[:uid], name: f[:name] }
            end
          end
        else
          facebook_me.friends.each do|f|
            friends[f.identifier] = { id: f.identifier, name: f.name }
          end
        end
        friends
      end
    end
    
    def facebook_friends_for_link(url, compId)
      friends = append_shares_loaded(facebook_friends(compId), url)
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