require 'jwt'
class Api::V1::SessionsController < ApplicationController
  def create
    session = Session.new params.permit(:email, :password)
    if session.valid?
      user = User.find_or_create_by email: params[:email]
      render status: 200, json: { jwt: user.generate_jwt, }
    else
      render json: {errors: session.errors}, status: 422
    end
  end
end
