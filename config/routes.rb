Rails.application.routes.draw do

  post '/register', to: 'auth#register'
  post '/login', to: 'auth3login'

  resources :users do
    resources :tasks
  end

end
