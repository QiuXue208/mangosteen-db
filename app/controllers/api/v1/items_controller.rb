class Api::V1::ItemsController < ApplicationController
  def index
    current_user_id = request.env['current_user_id']
    return head :unauthorized unless current_user_id
    # 根据user_id和时间范围查询
    items = Item.where({user_id: current_user_id})
      .where({created_at: params[:created_after]..params[:created_before]})
    render json: {resources: items, pagination: {
      page: params[:page],
      per_page: 10,
      count: Item.count
    }}
  end
  def create
    item = Item.new amount: params[:amount], notes: params[:notes]
    if item.save
      render json: { resource: item }
    else
      render json: { errors: item.errors }, status: 422
    end
  end
end
