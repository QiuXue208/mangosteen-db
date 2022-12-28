class Api::V1::ValidationCodesController < ApplicationController
  def create
    # 拦截1min内的请求
    if ValidationCode.exists?(email: params[:email], kind: 'sign_in', created_at: 1.minute.ago..Time.now)
      render :too_many_requests
      return
    end

    # 创建一条记录
    validation_code = ValidationCode.new email: params[:email], kind: 'sign_in'
    if validation_code.save
      render status: 200
    else
      render json: {errors: validation_code.errors}, status: 422
    end
  end
end
