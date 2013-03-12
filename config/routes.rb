WordPyramid::Application.routes.draw do
  resources :players
  resources :games do
    resources :turns
    member do
      post :prepend_letter
      post :append_letter
    end
  end


  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end