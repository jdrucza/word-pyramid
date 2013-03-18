WordPyramid::Application.routes.draw do
  resources :players
  resources :games do
    resources :turns
    member do
      post :challenge
      post :respond_to_challenge
      post :use_power_up
    end
  end

  match '/' => 'home#index', :as => 'home'

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users do
    member do
      put :add_power_ups
    end
  end
end