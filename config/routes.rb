Rails.application.routes.draw do
  devise_for :users
  
  resources :workspaces do
    resource :user_workspace, only: [:edit, :update] do
      delete 'remove/:user_id', on: :collection, action: :destroy, as: :remove_user
    end
    resource :invites, only: [:create]
    
    resources :chats do
      resources :chat_members, only: [:index, :new, :create, :destroy, :edit, :update]
      resources :messages, only: [:index, :new, :create, :destroy, :edit, :update, :marks_as_read] do
        member do
          post :marks_as_read
        end
      end
    end
  end

  resources :friends do
    member do
      post :accept
    end
  end

  get 'invites/accept/:token', to: 'invites#accept', as: 'accept_invite'

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Define the root path route
  root "home#index"
end
