require 'json'
require 'net/http'
class GoogleAuthenticationController < ApplicationController
  def authenticate
    response = Net::HTTP.get(URI("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{params[:id_token]}"))
    response = JSON.parse(response)
    render json: { error: 'Invalid token' } and return unless response['email'] && response['email_verified']
    password = Devise.friendly_token[0,20]
    @current_user = User.where(email: response['email']).first_or_create(password: password, first_name: response['given_name'], last_name: response['family_name'])
    @current_user.update(google_token: params[:id_token])
    render 'users/show'
  end
end