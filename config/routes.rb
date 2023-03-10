Rails.application.routes.draw do
  post '/microsoft_auth', to: 'microsoft_authentication#authenticate'
  post '/refresh_token', to: 'microsoft_authentication#refresh_token'
  get '/current_user', to: 'users#show_current_user'
  post '/google_auth', to: 'google_authentication#authenticate'
  devise_for :users, path: '', defaults: {format: :json}, path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'sessions',
  }

  resource :user, only: [:show, :update]
  get '/users', to: 'users#index', defaults: {format: :json}
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  default_url_options :host => "localhost:3000"

  root to: 'main#index'
end
