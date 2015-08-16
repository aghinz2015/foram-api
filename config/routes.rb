Rails.application.routes.draw do
  constraints defaults: { format: :json } do
    api version: 1, default: true do
      resources :forams, except: [:new, :edit, :create, :update]
    end

    match ':status_code', to: 'errors#show', constraints: { status_code: /\d{3}/ }, via: :all
  end
end
