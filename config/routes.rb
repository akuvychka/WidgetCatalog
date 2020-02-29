Rails.application.routes.draw do
  root to: 'sessions#new'
  resources :users, only: [:create, :new, :edit, :update] do
    collection do
      get 'me', to: 'users#me'
    end
  end
  resources :widgets
  resources :sessions, only: [:new, :create] do
    collection do
      delete :destroy, to: 'sessions#destroy'
    end
  end
  resource :password, only: [:update, :edit] do
    get 'forgot', to: 'passwords#forgot'
    post 'restore', to: 'passwords#restore'
  end
end
