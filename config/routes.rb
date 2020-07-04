Rails.application.routes.draw do
  get 'welcome/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  resources :users do
    member do
      post :borrow
    end
  end
  resources :books
  resources :transactions, only: %i[index]
end
