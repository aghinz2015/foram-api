Rails.application.routes.draw do
  api version: 1, default: true do

    post    'user/login',    to: 'sessions#create'
    delete  'user/logout',   to: 'sessions#destroy'

    resource :user, except: [:index, :new, :edit] do
      resources :mongo_sessions, only: [:index, :create, :update, :destroy]
      resource :settings_set, only: [:show, :update]
    end
    resources :forams, only: [:show, :index] do
      collection do
        get :attribute_names
        get :attribute_stats
        get :simulation_starts
      end
      resources :descendants, only: :index
    end
    resources :generations, only: :index
    resources :foram_filters, except: [:new, :edit] do
      get :attribute_names, on: :collection
    end
    resources :death_coordinates, only: :index
  end

  match ':status_code', to: 'errors#show', constraints: { status_code: /\d{3}/ }, via: :all
end
