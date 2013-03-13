WordPyramid::Application.routes.draw do
  resources :players
  resources :games do
    resources :turns
    member do
      post :challenge
      post :respond_to_challenge
    end
  end

  match '/' => 'home#index', :as => 'home'

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end