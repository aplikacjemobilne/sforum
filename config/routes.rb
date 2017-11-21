Rails.application.routes.draw do
  root to: 'static#index'

  resources :posts
  resources :topics
  resources :courses
  resources :students
end
