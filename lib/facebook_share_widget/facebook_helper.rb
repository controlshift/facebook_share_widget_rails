module FacebookShareWidget
  module FacebookHelpers
    def facebook_access_token
      session[:facebook_access_token]
    end
  
    def has_facebook_access
      session[:facebook_access_token].present?
    end
  
    def facebook_me
      FbGraph::User.me(self.facebook_access_token)
    end
  
    def facebook_user(facebook_id)
      FbGraph::User.new(facebook_id, access_token: self.facebook_access_token)
    end
  
    def facebook_friends
      friends = []
      friends += facebook_me.friends.map {|f| { id: f.identifier, name: f.name } }
      friends
    end
  
    def post(post = {})
      facebook_id = post.delete(:facebook_id)
      facebook_user(facebook_id).feed!(post)
    end
  end
end