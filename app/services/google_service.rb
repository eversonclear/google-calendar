require 'json'
require 'net/http'

class GoogleService
  def initialize 
    @client_id = ENV["GOOGLE_CLIENT_ID"]
    @client_secret = ENV["GOOGLE_CLIENT_SECRET_ID"]
  end

  def get_user_data(id_token)
    user_data = Net::HTTP.get(URI("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{id_token}"))
    JSON.parse(user_data)
  end

  def generate_refresh_token(authorization_code)
    url = URI('https://accounts.google.com/o/oauth2/token')

    params = {
      code: authorization_code,
      client_id: @client_id,
      client_secret: @client_secret,
      grant_type: "authorization_code",
      access_type: "offline",
      redirect_uri: 'http://localhost:3001'
    }

    res = Net::HTTP.post_form(url, params)
    JSON.parse(res.body)
  end

  def access_token_is_valid?(date_expire)
    (date_expire - 5.minutes) > Time.now
  end

  def refresh_token(refresh_token)
    url = URI('https://oauth2.googleapis.com/token')

    params = {
      refresh_token: refresh_token,
      client_id: @client_id,
      client_secret: @client_secret,
      grant_type: 'refresh_token',
    }

    res = Net::HTTP.post_form(url, params)
    JSON.parse(res.body)
  end
end
