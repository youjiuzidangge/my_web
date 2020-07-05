Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  resources :users do
    member do
      post 'borrow/:book_id', to: 'users#borrow'
      post 'restore/:book_id', to: 'users#restore'
    end
  end
  resources :books
  resources :transactions, only: %i[index] do
    collection do
      post :ack
    end
  end
end
