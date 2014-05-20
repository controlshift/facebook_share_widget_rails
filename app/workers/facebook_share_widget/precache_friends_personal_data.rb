module FacebookShareWidget
  class PrecacheFriendsPersonalData
    include Sidekiq::Worker

    def perform(facebook_access_token, personal_data_type)

      results = Rails.cache.fetch("friends_for_#{facebook_access_token}_of_#{personal_data_type}", :expires_in => 1.hour) do
        FacebookShareWidget::FriendsPersonalData.new(facebook_access_token: facebook_access_token, personal_data_type: personal_data_type).retrieve
      end

      results.each_with_index do |personal_data|
        PrecacheFriendsWithPersonalDataId.perform_async(facebook_access_token, personal_data_type, personal_data['id'])
      end

    end
  end
end