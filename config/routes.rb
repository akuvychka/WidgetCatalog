Rails.application.routes.draw do
  root to: 'users#sign_in'
  resources :users do
    collection do
      get 'sign_in', to: 'users#sign_in'
    end
  end
  resources :widgets
end
