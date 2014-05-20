module FacebookShareWidget
  class FriendsPersonalData < LoadFbData
    def retrieve
      data = Hash.new(0)
      FbGraph::Query.new("SELECT uid, name, #{sanitize_personal_data_type(personal_data_type)} FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1=me()) AND #{sanitize_personal_data_type(personal_data_type)}").
        fetch(access_token: self.facebook_access_token).each do|f|
        data[get_data_array_for(personal_data_type, f, true).first] += 1
      end
      Hash[data.sort {|a,b| b[1]<=>a[1]}].keys[0..4]
    end
  end
end