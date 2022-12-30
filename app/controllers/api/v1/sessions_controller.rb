require 'jwt'
class Api::V1::SessionsController < ApplicationController
  def create
    # 存在账号code，且used_at为空时才可以登录
    canSignin = ValidationCode.exists?(email: params[:email], code: params[:code], used_at: nil)
    return render status: 401 unless canSignin
    user = User.find_or_create_by_email(params[:email])
    render status: 200, json: { jwt: user.generate_jwt, }
  end
end
