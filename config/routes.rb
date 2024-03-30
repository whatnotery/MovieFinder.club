Rails.application.routes.draw do
  devise_for :users
  resources :users do
    collection do
      get 'current_user', to: 'users#current_user'
    end
  end
  
    get '/films' => "films#index"
    post '/films' => 'films#twilio_response'

end
