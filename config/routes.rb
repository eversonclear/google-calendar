Rails.application.routes.draw do
  resources :event_attendees
  resources :events
  resources :calendars
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

  post '/import_calendars_and_events', to: 'calendars#import_google_calendar'
  get '/events_by_date', to: 'events#events_by_date'
  get '/events_by_week', to: 'events#events_by_week'
  root to: 'main#index'
end
