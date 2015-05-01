Rails.application.routes.draw do
  resources :forams, except: [:new, :edit]
end
