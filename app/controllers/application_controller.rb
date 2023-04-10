class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::HttpAuthentication::Token::ControllerMethods
  require 'jwt'

  respond_to :json

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user

  private
  def refresh_token_if_invalid
    @google_service = GoogleService.new

    if !@google_service.access_token_is_valid?(current_user.google_expire_token)
      data_token = @google_service.refresh_token(current_user.google_refresh_token)
      @current_user.update(google_token: data_token['access_token'], google_expire_token: Time.now + data_token['expires_in'])
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end

  def current_user
    @current_user ||= super || User.find(@current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end

  def authenticate_user
    if request.headers['Authorization'].present?
      authenticate_or_request_with_http_token do |token|
        begin
          jwt_payload = JWT.decode(token, ENV['SECRET_KEY_BASE']).first
          @current_user_id = jwt_payload['id']
        rescue JWT::ExpiredSignature
          head :unauthorized
        rescue JWT::VerificationError
          head :unauthorized
        rescue JWT::DecodeError
          head :unauthorized
        end
      end
    end
  end
end
