class Api::V1::OrdersController < ApplicationController

  def index
    orders = @current_user.orders.all
    render json: serialize_order(orders), status: :ok
  end

  def show
    order = Order.includes(:order_items).find_by(id: params[:id])

    if order
      render json: serialize_order(order), status: :ok
    else
      render json: { error: 'Order not found' }, status: :not_found
    end
  end

  def create
    order = Order.new(order_params)
    order.user_id=@current_user.id
    if order.save
      OrderMailer.order_confirmation(order).deliver_later
      render json: { "message":"Order Placed successfully"}, status: :created
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    order = Order.find_by(id: params[:id])
    return render json: { error: 'Order not found' }, status: :not_found unless order
  
    if order.update(order_params)
      render json: { "message":"Order Updated successfully"}, status: :ok
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
    params.require(:order).permit(
      :total_price,
      order_items_attributes: [:product_id, :quantity]
    )
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
