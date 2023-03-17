require 'json'
require 'net/http'
class GoogleAuthenticationController < ApplicationController
  before_action :set_google_service
  def authenticate
    tokens = @google_service.generate_tokens(params[:code], params[:web].present?)
    render json: { error: 'Invalid Auth Code' }, status: :bad_request and return unless tokens['refresh_token'] && tokens['access_token']

    user_data = @google_service.get_user_data(tokens['access_token'])
    password = Devise.friendly_token[0,20]
    @current_user = User.where(email: user_data['email']).first_or_create(password: password, first_name: user_data['given_name'], last_name: user_data['family_name'])
    @current_user.update(google_token: tokens["access_token"], google_refresh_token: tokens["refresh_token"], google_expire_token: Time.now + tokens['expires_in'])
    render 'users/show'
  end

  def set_google_service
    @google_service ||= GoogleService.new
  end
end