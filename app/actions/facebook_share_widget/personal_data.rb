module FacebookShareWidget
  class PersonalData < LoadFbData
    def retrieve
      data = []
      FbGraph::Query.new("SELECT #{sanitize_personal_data_type(personal_data_type)} FROM user WHERE uid = me()").
        fetch(access_token: self.facebook_access_token).each do |data_object|
        data += get_data_array_for(personal_data_type, data_object)
      end
      data
    end
  end
end