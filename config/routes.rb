Rails.application.routes.draw do
  constraints defaults: { format: :json } do
    api version: 1, default: true do

      post    'user/login',    to: 'sessions#create'
      delete  'user/logout',   to: 'sessions#destroy'

      resource :user, only: [:create, :update, :destroy] do
        resources :mongo_sessions, only: [:index, :create, :update, :destroy]
      end
      resources :forams, only: [:show, :index]
      resources :generations, only: :index
      resources :foram_filters, except: [:new, :edit]
    end

    match ':status_code', to: 'errors#show', constraints: { status_code: /\d{3}/ }, via: :all
  end
end
