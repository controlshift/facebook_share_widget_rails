FacebookShareWidget::Engine.routes.draw do
  get 'facebook' => 'facebook#index'
  get 'facebook/friends' => 'facebook#friends'
  get 'facebook/:personal_data_type/data' => 'facebook#personal_data'
  get 'facebook/:personal_data_type/friends_data' => 'facebook#friends_personal_data'
  get 'facebook/share-redirect' => 'facebook#share'
end
