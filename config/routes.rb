Rails.application.routes.draw do
  root 'transactions#index'
  resources :transactions, only: [:index] do
    collection do
      post :import
    end
  end
end
