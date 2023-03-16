require 'json'
require 'net/http'
class GoogleAuthenticationController < ApplicationController
  before_action :set_google_service
  def authenticate
    user_data = @google_service.get_user_data(params[:id_token])
    render json: { error: 'Invalid token' } and return unless user_data['email'] && user_data['email_verified']

    password = Devise.friendly_token[0,20]
    @current_user = User.where(email: user_data['email']).first_or_create(password: password, first_name: user_data['given_name'], last_name: response['family_name'])
    
    data_token = @google_service.generate_refresh_token(params[:code])
    @current_user.update(google_token: data_token["access_token"], google_refresh_token: data_token["refresh_token"], google_expire_token: Time.now + data_token['expires_in'])
    
    render 'users/show'
  end

  def set_google_service
    @google_service ||= GoogleService.new
  end
end