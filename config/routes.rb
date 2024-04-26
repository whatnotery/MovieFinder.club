Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: "users/sessions"}

  root "static#home"

  namespace :api do
    resources :films do
      collection do
        get "/random", to: "films#random"
        get "/search", to: "films#search"
        post "/twilio", to: "films#twilio"
        get "/:id", to: "films#show"
      end
    end
    resources :users, only: :show
  end

  devise_scope :user do
    get "/sign_in", to: "users/sessions#new"
  end

  get "/sign_up", to: "users#new"
  get "/discover", to: "static#random_film"
  get "/search", to: "films#search"

  resources :users do
    collection do
      get "/current_user", to: "users#logged_in_user"
      get "/:id/likes", to: "users#likes"
      get "/:id/reviews", to: "users#reviews"
      get "/:id/favorites", to: "users#favorites"
    end
  end

  resources :films, only: [:index, :show] do
    collection do
      post "/:id/like", to: "films#like"
      post "/:id/unlike", to: "films#unlike"
      post "/:id/favorite", to: "films#favorite"
      post "/:id/unfavorite", to: "films#unfavorite"
      get "/:id/liked_by", to: "films#liked_by"
      post "/:id/review", to: "reviews#create"
      get "/:id/review", to: "reviews#new"
      get "/:id/reviews", to: "reviews#index"
      get "/:id/reviews/:review_id", to: "reviews#show"
      get "/recent", to: "films#recent"
    end
  end
end
