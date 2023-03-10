require 'json'
require 'net/http'

class MicrosoftService
  def get_user_authenticated(azure_token)
    uri = URI.parse('https://graph.microsoft.com/v1.0/me')
    req = Net::HTTP::Get.new(uri.to_s)
    req['Authorization'] = "Bearer #{azure_token}"

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }

    (res.is_a? Net::HTTPSuccess) ? JSON.parse(res.body) : raise(JSON.parse(res.body)['error']['message'])
  end

  def refresh_token(azure_refresh_token, origin)
    uri = URI.parse('https://login.microsoftonline.com/common/oauth2/v2.0/token')

    http_client = Net::HTTP.new(uri.host, uri.port)
    http_client.use_ssl = true

    encoded_form = URI.encode_www_form(refresh_params(azure_refresh_token))
    headers = { content_type: 'application/x-www-form-urlencoded', origin: origin }
    res = http_client.request_post(uri.to_s, encoded_form, headers)

    (res.is_a? Net::HTTPSuccess) ? JSON.parse(res.body) : raise(JSON.parse(res.body)['error']['message'])
  end

  private

  def refresh_params(azure_refresh_token)
    {
      grant_type: 'refresh_token',
      refresh_token: azure_refresh_token,
      client_id: '7a59a59c-a48a-4ddc-9542-c2ce3c15cb2b',
      scope: [
        'openid',
        'offline_access',
        'profile',
        'User.Read'
      ]
    }
  end
end
