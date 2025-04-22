class Api::V1::OrderItemsController < ApplicationController
  def create
    order_item = OrderItem.new(order_item_params)
    if order_item.save
      render json: order_item, status: :created
    else
      render json: order_item.errors, status: :unprocessable_entity
    end
  end

  def update
    order_item = OrderItem.find_by(id: params[:id])
    if order_item && order_item.update(order_item_params)
      render json: order_item
    else
      render json: { errors: order_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    order_item = OrderItem.find_by(id: params[:id])
    if order_item
      order_item.destroy
      head :no_content
    else
      render json: { errors: "Order Item not found" }, status: :not_found
    end
  end

  private

  def order_item_params
    params.require(:order_item).permit(:order_id, :product_id, :quantity)
  end
end