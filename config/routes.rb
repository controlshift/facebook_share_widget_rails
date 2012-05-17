FacebookShareWidget::Engine.routes.draw do
  get 'facebook' => 'facebook#index'
  get 'facebook/friends' => 'facebook#friends'
  post 'facebook/share' => 'facebook#share'
end
