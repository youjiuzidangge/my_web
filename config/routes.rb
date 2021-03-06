Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#index'

  resources :users do
    member do
      get :detail
      post 'borrow/:book_id', to: 'users#borrow'
      post 'restore/:book_id', to: 'users#restore'
    end
  end
  resources :books do
    member do
      get :detail
      get :income
    end
  end
  resources :transactions, only: %i[index] do
    collection do
      post :ack
    end
  end
end
