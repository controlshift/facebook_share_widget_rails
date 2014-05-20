module FacebookShareWidget
  class PrecacheFriendsWithPersonalDataId
    include Sidekiq::Worker

    def perform(facebook_access_token, personal_data_type, personal_data_id)

      Rails.cache.fetch("friends_for_#{facebook_access_token}_for_#{personal_data_type}_as_#{personal_data_id}", :expires_in => 1.hour) do
        FacebookShareWidget::Friends.new(facebook_access_token: facebook_access_token, personal_data_type: personal_data_type, personal_data_id: personal_data_id).retrieve
      end
    end
  end
end