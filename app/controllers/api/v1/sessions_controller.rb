require 'jwt'
class Api::V1::SessionsController < ApplicationController
  def create
    # 存在账号code，且used_at为空时才可以登录
    canSignin = ValidationCode.exists?(email: params[:email], code: params[:code], used_at: nil)
    user = User.find_by_email(params[:email])
    # 等价于 return render status: 401 unless canSignin
    if !canSignin
      return render status: 401
    end
    if user
      payload = {user_id: user.id}
      hmac_secret = Rails.application.credentials.hmac_secret
      token = JWT.encode payload, hmac_secret, 'HS256'
      p token
      render status: 200, json: {
        jwt: token
      }
    else
      render status: 404, json: { errors: '用户不存在' }
    end
  end
end
