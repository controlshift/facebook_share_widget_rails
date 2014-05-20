module FacebookShareWidget
  class Friends < LoadFbData
    def retrieve
      friends = {}
      if personal_data_id.present?
        FbGraph::Query.new("SELECT uid, name, #{sanitize_personal_data_type(personal_data_type)}.id FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1=me())").
          fetch(access_token: self.facebook_access_token).each do|f|
          if(get_data_array_for(personal_data_type, f).collect {|a| a[:id]}.include?(personal_data_id))
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
end