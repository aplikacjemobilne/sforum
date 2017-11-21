Rails.application.routes.draw do
  root to: 'static#index'

  get '/api' => redirect('/swagger/dist/index.html?url=/api-docs.json')

  get    '/feed',    to: 'static#feed'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '/courses/:id/follow', to: 'courses#follow'
  get '/courses/:id/unfollow', to: 'courses#unfollow'

  resources :students
  resources :courses do
    resources :topics, only: [:new, :create, :edit, :update, :show, :destroy] do
      resources :posts, only: [:new, :create, :edit, :update, :show, :destroy]
    end
  end
end
