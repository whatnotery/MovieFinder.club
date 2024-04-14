Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  
  root "static#home"
  get '/csrf_token', to: 'application#csrf_token'

  resources :users do
    collection do
      get 'current_user', to: 'users#current_user'
      get '/:id/likes', to: 'users#likes'
      get '/:id/reviews', to: 'users#reviews'
    end
  end
  
  resources :films, only: [:index, :show]  do
    collection do
      post '/twilio', to: 'films#twilio_response'
      get '/random', to: "films#random"
      get '/search', to: "films#search"
      post '/:id/like', to: 'films#like'
      post '/:id/unlike', to: 'films#unlike'
      get '/:id/liked_by', to: 'films#liked_by'
      post '/:id/reviews', to: 'reviews#create'
      get '/:id/reviews', to: 'reviews#index'
      get '/:id/reviews/:review_id', to: 'reviews#show' 
      get '/recently_reviewed', to: 'films#recently_reviewed'
      get '/recently_discovered', to: 'films#recently_discovered'
    end
  end
end
