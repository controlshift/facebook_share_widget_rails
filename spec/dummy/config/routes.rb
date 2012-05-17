Rails.application.routes.draw do
  mount FacebookShareWidget::Engine => "/widget"
end
