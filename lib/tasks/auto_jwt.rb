class AutoJwt
  def initialize(app)
    @app = app
  end

  def call(env)
    header = env['HTTP_AUTHORIZATION']
    # formatter: Bearer xxx
    jwt = header.split(' ')[1] rescue ''
    # decode jwt
    decoded_arr = JWT.decode jwt, Rails.application.credentials.hmac_secret, true, { algorithm: 'HS256'} rescue nil
    env['current_user_id'] = decoded_arr[0]['user_id'] rescue nil
    @status, @headers, @response = @app.call(env)
    [@status, @headers, @response]
  end
end