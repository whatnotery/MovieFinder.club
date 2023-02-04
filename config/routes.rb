Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    get '/films' => "films#index"
    post '/films' => 'films#twilio'

end
