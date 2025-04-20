class Api::V1::OrdersController < ApplicationController

  def index
    orders = Order.includes(:order_items).all
    render json: serialize_order(orders)
  end

  def show
    order = Order.includes(:order_items).find_by(id: params[:id])
  
    if order
      render json: serialize_order(order)
    else
      render json: { error: 'Order not found' }, status: :not_found
    end
  end

  def create
    order = Order.new(order_params)
    if order.save
      render json: order, status: :created
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    order = Order.find_by(id: params[:id])
    return render json: { error: 'Order not found' }, status: :not_found unless order
  
    if order.update(order_params)
      render json: order
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    order = Order.find_by(id: params[:id])
    return render json: { error: 'Order not found' }, status: :not_found unless order
  
    order.destroy
    head :no_content
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :total_price)
  end

  def serialize_order(order)
    order.as_json(
      only: [:id, :total_price],
      methods:[:user_name,:date],
      include: {
        order_items: {
          only: [:quantity],
          methods: [:product_name, :product_price]
        }
      }
    )
  end
  
end
