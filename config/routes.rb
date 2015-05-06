Rails.application.routes.draw do
  constraints subdomain: 'api', defaults: { format: :json } do
    api version: 1, default: true do
      resources :forams, except: [:new, :edit]
    end
  end
end
