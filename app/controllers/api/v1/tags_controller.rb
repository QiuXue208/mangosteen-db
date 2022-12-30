class Api::V1::TagsController < ApplicationController
  # 创建标签
  def create
    current_user = User.find request.env['curent_user_id']
    return render status: 401 if current_user.nil?
    tag = Tag.new(
      user_id: current_user.id,
      name: params[:name],
      sign: params[:sign]
    )
    if tag.save
      render json: { resource: tag }
    else
      render json: { errors: tag.errors }, status: 422
    end
  end

  # 获取标签列表
  def index
    current_user = User.find request.env['curent_user_id']
    return render status: 401 if current_user.nil?
    tags = Tag.where(user_id: current_user.id).page(params[:page])
    render json: {resources: tags, pagination: {
      page: params[:page] || 1,
      per_page: Tag.default_per_page,
      count: Tag.count
    }}
  end

  # 获取标签详情
  def show
     tag = Tag.find params[:id]
     return head 403 unless tag.user_id == request.env['curent_user_id']
     render json: { resource: tag }
  end

  # 更新标签
  def update
    tag = Tag.find params[:id]
    tag.update params.permit(:name, :sign)
    if tag.errors.empty?
      render json: { resource: tag }
    else
      render json: { errors: tag.errors }, status: 422
    end
  end

  # 删除标签
  def destory
    tag = Tag.find params[:id]
    return head 403 unless tag.user_id == request.env['curent_user_id']
    tag.deleted_at = Time.now
    if tag.save
      head 200
    else
      render json: { errors: tag.errors}, status: 422
    end
  end
end
