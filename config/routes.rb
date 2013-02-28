FacebookShareWidget::Engine.routes.draw do
  get 'facebook' => 'facebook#index'
  get 'facebook/friends' => 'facebook#friends'
  get 'facebook/employers' => 'facebook#employers'
  get 'facebook/change_employer' => 'facebook#change_employer'
  get 'facebook/share-redirect' => 'facebook#share'
end
