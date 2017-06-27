Rails.application.routes.draw do
  resources :blogs do
    resources :entries, only: [:new, :create, :show] do
      resources :comments, only: [:create]
    end
  end
  resources :entries, only: [:edit, :update, :destroy]
  resources :comments, only: [:destroy] do
    patch 'approve', on: :member
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
