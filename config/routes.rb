Rails.application.routes.draw do
  devise_for :users
  resources :users do
    collection do
      get 'current_user', to: 'users#current_user'
    end
  end
  
  resources :films do
    collection do
      post '/twilio' => 'films#twilio_response'
      get '/random' => "films#random"
      post '/:id/like' => 'films#like'
      post '/:id/unlike' => 'films#unlike'
      get '/:id/liked_by' => 'films#liked_by'
    end
  end
end
