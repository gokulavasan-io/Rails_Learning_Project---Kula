class Api::V1::OrdersController < ApplicationController

  def index
    orders = Order.all
    render json: orders
  end

  def show
    order = Order.find_by(id: params[:id])
    render json: order
  end

  def create
    order = Order.new(order_params)
    if order.save
      render json: order, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    order = Order.find_by(id: params[:id])
    if order&.update(order_params)
      render json: order
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    order = Order.find_by(id: params[:id])
    if order
      order.destroy
      head :no_content
    else
      render json: { errors: product.errors.full_messages }, status: :not_found
    end
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :total_price)
  end
  
end
