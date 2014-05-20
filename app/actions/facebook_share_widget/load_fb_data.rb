module FacebookShareWidget
  class LoadFbData < ApplicationAction
    attr_accessor :facebook_access_token, :personal_data_id, :personal_data_type

    private

    def get_data_array_for personal_data_type, data_object, first=false
      tokens = personal_data_type.split('.').collect(&:to_sym)
      iteratable_value = data_object[tokens.delete(tokens[0])]
      iteratable_value = [iteratable_value[0]] if first
      tokens.each do |token|
        iteratable_value = iteratable_value.collect {|a| a[token]}
      end
      iteratable_value
    end

    def facebook_me
      FbGraph::User.me(self.facebook_access_token)
    end

    def sanitize_personal_data_type(s)
      if ['work.employer'].include?(s)
        s
      else
        nil
      end
    end
  end
end