class Api::V1::MesController < ApplicationController
  def show
    # get jwt from header
    header = request.headers['Authorization']
    # formatter: Bearer xxx
    jwt = header.split(' ')[1] rescue ''
    # decode jwt
    decoded_token = JWT.decode jwt, Rails.application.credentials.hmac_secret, true, { algorithm: 'HS256'} rescue nil
    return render 400 if decoded_token.nil?
    user_id = decoded_token[0]['user_id']
    user = User.find user_id
    return head 404 if user.nil?
    render json: { resource: user }
  end
end
