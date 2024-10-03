Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :workspaces do
    resources :user_workspaces, only: [:edit, :update, :destroy, :index], param: :user_id do
      member do
        post :block
        post :unblock
      end
    end
    resource :invites, only: [:create]
    
    resources :chats do
      resources :chat_members, only: [:index, :new, :create, :destroy, :edit, :update]
      resources :messages, only: [:index, :new, :create, :destroy, :edit, :update] do
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

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "home#index"
end
