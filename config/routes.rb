Rails.application.routes.draw do
  root to: 'sessions#new'
  resources :users do
    collection do
      get 'sign_in', to: 'users#sign_in'
    end
  end
  resources :widgets
  resources :sessions, only: [:new, :create] do
    collection do
      delete :destroy, to: 'sessions#destroy'
    end
  end
end
