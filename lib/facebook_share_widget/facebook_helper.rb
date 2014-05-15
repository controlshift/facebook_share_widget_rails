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
  
    def my_personal_data personal_data_type
      Rails.cache.fetch("#{personal_data_type}_of_#{self.facebook_access_token}", :expires_in => 24.hours) do
        data = []
        FbGraph::Query.new("SELECT #{sanitize_personal_data_type(personal_data_type)} FROM user WHERE uid = me()").
        fetch(access_token: self.facebook_access_token).each do |data_object|
          data += get_data_array_for(personal_data_type, data_object)
        end
        data
      end
    end
    
    def get_data_array_for personal_data_type, data_object, first=false
      tokens = personal_data_type.split('.').collect(&:to_sym)
      iteratable_value = data_object[tokens.delete(tokens[0])]
      iteratable_value = [iteratable_value[0]] if first
      tokens.each do |token|
        iteratable_value = iteratable_value.collect {|a| a[token]}
      end
      iteratable_value
    end

    def fb_friends_personal_data personal_data_type
      Rails.cache.fetch("friends_for_#{self.facebook_access_token}_of_#{personal_data_type}", :expires_in => 1.hour) do
        data = Hash.new(0)
        FbGraph::Query.new("SELECT uid, name, #{sanitize_personal_data_type(personal_data_type)} FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1=me()) AND #{sanitize_personal_data_type(personal_data_type)}").
        fetch(access_token: self.facebook_access_token).each do|f|
          data[get_data_array_for(personal_data_type, f, true).first] += 1
        end
        Hash[data.sort {|a,b| b[1]<=>a[1]}].keys[0..4]
      end
    end

    def facebook_friends(personal_dataId, personal_data_type)
      Rails.cache.fetch("friends_for_#{self.facebook_access_token}_for_#{personal_data_type}_as_#{personal_dataId}", :expires_in => 1.hour) do
        friends = {}
        if(personal_dataId != nil)
          FbGraph::Query.new("SELECT uid, name, #{sanitize_personal_data_type(personal_data_type)}.id FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1=me())").
          fetch(access_token: self.facebook_access_token).each do|f|
            if(get_data_array_for(personal_data_type, f).collect {|a| a[:id]}.include?(personal_dataId))
              friends[f[:uid].to_s] = { id: f[:uid], name: f[:name] }
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

    private
    def sanitize_personal_data_type(s)
      if ['work.employer'].include?(s)
        s
      else
        nil
      end
    end

    def s(string)
      ActiveRecord::Base.sanitize(string)
    end
  end
end