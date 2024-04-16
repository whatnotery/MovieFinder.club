Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: "users/sessions"}

  root "static#home"

  namespace :api do
    resources :films do
      collection do
        get "/random", to: "films#random"
        post "twilio", to: "films#twilio"
      end
    end
  end

  devise_scope :user do
    get "/sign_in", to: "users/sessions#new"
  end

  get "/sign_up", to: "users#new"
  get "/discover", to: "static#random_film"

  resources :users do
    collection do
      get "current_user", to: "users#logged_in_user"
      get "/:id/likes", to: "users#likes"
      get "/:id/reviews", to: "users#reviews"
    end
  end

  resources :films, only: [:index, :show] do
    collection do
      get "/search", to: "films#search"
      post "/:id/like", to: "films#like"
      post "/:id/unlike", to: "films#unlike"
      post "/:id/favorite", to: "films#favorite"
      post "/:id/unfavorite", to: "films#unfavorite"
      get "/:id/liked_by", to: "films#liked_by"
      post "/:id/reviews", to: "reviews#create"
      get "/:id/reviews", to: "reviews#index"
      get "/:id/reviews/:review_id", to: "reviews#show"
      get "/recently_reviewed", to: "films#recently_reviewed"
      get "/recently_discovered", to: "films#recently_discovered"
    end
  end
end
