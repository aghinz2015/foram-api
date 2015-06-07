Rails.application.routes.draw do
  constraints defaults: { format: :json } do
    api version: 1, default: true do
      resources :forams, except: [:new, :edit, :create, :update]
    end
  end
end
