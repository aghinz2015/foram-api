Rails.application.routes.draw do
  constraints defaults: { format: :json } do
    api version: 1, default: true do
      resources :users, only: [:create, :destroy] do
        collection do
          patch   :update
          post    :login,   to: 'sessions#create'
          delete  :logout,  to: 'sessions#destroy'
        end
      end
      resources :forams, only: [:show, :index]
      resources :generations, only: :index
    end

    match ':status_code', to: 'errors#show', constraints: { status_code: /\d{3}/ }, via: :all
  end
end
