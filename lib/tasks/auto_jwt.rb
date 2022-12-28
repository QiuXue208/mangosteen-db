class AutoJwt
  def initialize(app)
    @app = app
  end

  def call(env)
    # 跳过 以下路径 的检查
    return @app.call(env) if ['/api/v1/session', '/api/v1/validations_code'].includes? env['PATH_INFO']
    header = env['HTTP_AUTHORIZATION']
    # formatter: Bearer xxx
    jwt = header.split(' ')[1] rescue ''
    begin
      # decode jwt
      decoded_arr = JWT.decode jwt, Rails.application.credentials.hmac_secret, true, { algorithm: 'HS256'} rescue nil
    rescue JWT::ExpiredSignature
      return [401, {}, [JSON.generate({reason: 'Token expired'})]]
    rescue
      return [401, {}, [JSON.generate({reason: 'Invalid token'})]]
    end
    env['current_user_id'] = decoded_arr[0]['user_id'] rescue nil
    @status, @headers, @response = @app.call(env)
    [@status, @headers, @response]
  end
end