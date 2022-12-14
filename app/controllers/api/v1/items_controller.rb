class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.page params[:page]
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
      render json: { errors: item.errors }
    end
  end
end
