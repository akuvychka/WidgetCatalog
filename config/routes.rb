Rails.application.routes.draw do
  root to: 'sessions#new'
  resources :users, only: [:create, :new, :edit, :update] do
    collection do
      get 'me', to: 'users#me'
      get 'change_password', to: 'users#edit_password'
      put 'change_password', to: 'users#save_password'
    end
  end
  resources :widgets
  resources :sessions, only: [:new, :create] do
    collection do
      delete :destroy, to: 'sessions#destroy'
    end
  end
end
