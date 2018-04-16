module AuthenticationModule

  # Scopes required by the app
  SCOPES = [ 'openid',
             'profile',
             'offline_access',
             'User.Read',
             'Contacts.Read' ]

  private

  def client
    OAuth2::Client.new(ENV["outlook-client_id"],
                       ENV["outlook-client_secret"],
                       site: 'https://login.microsoftonline.com',
                       authorize_url: '/common/oauth2/v2.0/authorize',
                       token_url: '/common/oauth2/v2.0/token')
  end

  def get_login_url
    client.auth_code.authorize_url(redirect_uri: authorize_url, scope: SCOPES.join(' '))
  end

  def get_token_from_code(code)
    client.auth_code.get_token(code, redirect_uri: authorize_url, scope: SCOPES.join(' '))
  end

  def get_access_token
    return unless $redis.get('outlook_token')
    token = OAuth2::AccessToken.from_hash(client, JSON.parse($redis.get('outlook_token')))
    if token.expired?
      token = token.refresh!
      $redis.set("outlook_token", auth_params(token).to_json)
    end
    token.token
  end

  def auth_params(token)
    params.merge(access_token: token.token, refresh_token: token.refresh_token, expires_at: token.expires_at)
  end

  def get_outlook_contacts(token)
    begin
      callback = Proc.new do |r| 
        r.headers['Authorization'] = "Bearer #{token}"
      end
      graph = MicrosoftGraph.new(base_url: 'https://graph.microsoft.com/v1.0',
                                cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, 'metadata_v1.0.xml'),
                                &callback)
      graph.me.contacts.order_by('givenName asc')
    rescue Exception => e
      flash[:danger] = e
      redirect_to imports_path
    end
  end
end