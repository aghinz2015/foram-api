Rails.application.routes.draw do
  constraints defaults: { format: :json } do
    api version: 1, default: true do
      namespace :users do
        resources :sessions, only: [:create, :destroy]
        resources :registrations, only: [:create, :update, :destroy]
      end
      resources :forams, only: [:show, :index]
      resources :generations, only: :index
    end

    match ':status_code', to: 'errors#show', constraints: { status_code: /\d{3}/ }, via: :all
  end
end
