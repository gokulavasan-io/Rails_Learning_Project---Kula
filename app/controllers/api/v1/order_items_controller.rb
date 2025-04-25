class Api::V1::OrderItemsController < ApplicationController
  before_action :set_order_item, only: [ :update, :destroy ]

  def update
    @order_item.update!(order_item_params)
    render json: { message: "Order Item updated successfully" }, status: :ok
  end

  def destroy
    @order_item.destroy
    head :no_content
  end

  private

  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def order_item_params
    params.require(:order_item).permit(:quantity)
  end
end
