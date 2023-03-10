require 'json'
require 'net/http'
class MicrosoftAuthenticationController < ApplicationController
  def authenticate
    microsoft_user = microsoft_service.get_user_authenticated(params[:azure_token])

    password = Devise.friendly_token[0, 20]
    @current_user = User.where(email: microsoft_user['userPrincipalName'])
                        .first_or_create(password:, first_name: microsoft_user['givenName'], last_name: microsoft_user['surname'])

    @current_user.update(azure_token: params[:azure_token], azure_expire_token: params[:azure_expire_token],
                         azure_refresh_token: params[:azure_refresh_token])

    render 'users/show'
  rescue Exception => e
    render json: { error: e.message }, status: :bad_request
  end

  def refresh_token
    refresh_data = microsoft_service.refresh_token(current_user.azure_refresh_token, params[:origin])

    current_user.update(azure_token: refresh_data['access_token'],
                        azure_expire_token: Time.now + refresh_data['expires_in'])

    render 'users/show'
  rescue Exception => e
    render json: { error: e.message }, status: :bad_request
  end

  private
  
  def microsoft_service
    @microsoft_service ||= MicrosoftService.new
  end
end
