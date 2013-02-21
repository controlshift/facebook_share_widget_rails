FacebookShareWidget::Engine.routes.draw do
  get 'facebook' => 'facebook#index'
  get 'facebook/friends' => 'facebook#friends'
  get 'facebook/employers' => 'facebook#employers'
  post 'facebook/share' => 'facebook#share'
end
