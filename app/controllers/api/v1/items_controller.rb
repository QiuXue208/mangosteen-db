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
    # permit会从params中提取出指定的参数
    item = Item.new params.permit(:amount, :notes, :tag_id, :happen_at, :kind)
    item.user_id = request.env['current_user_id']
    if item.save
      render json: { resource: item }
    else
      render json: { errors: item.errors }, status: 422
    end
  end

  def summary
    hash = Hash.new
    items = Item
      .where(user_id: request.env['current_user_id'])
      .where(happen_at: params[:happened_after]..params[:happened_before])
      .where(kind: params[:kind])
    items.each do |item|
      if params[:group_by] == 'happen_at'
        key = item.happen_at.in_time_zone('Beijing').strftime('%Y-%m-%d')
        hash[key] ||= 0
        hash[key] += item.amount
      else params[:group_by] == 'tag_id'
        key = item.tag_id
        hash[key] ||= 0
        hash[key] += item.amount
      end
    end

    groups = hash.map { |k, v| {"#{params[:group_by]}": k, amount: v} }

    if params[:group_by] == 'happen_at'
      groups.sort! { |a, b| a[:happen_at] <=> b[:happen_at] }
    elseif params[:group_by] == 'tag_id'
      groups.sort! { |a, b| b[:amount] <=> a[:amount] }
    end

    render json: {
      resources: groups,
      total: items.sum(:amount)
    }
  end
end
