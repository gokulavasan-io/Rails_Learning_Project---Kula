class Api::V1::OrdersController < ApplicationController
  before_action :set_order, only: [ :show, :update, :destroy ]

  def index
    orders = Rails.cache.fetch("users/#{@current_user.id}/orders", expires_in: 10.minutes) do
      @current_user.orders.includes(order_items: :product).to_a
    end
    render json: serialize_order(orders), status: :ok
  end

  def show
    render json: serialize_order(@order), status: :ok
  end

  def create
    order = Order.new(order_params)
    order.user = @current_user
    order.save!

    Rails.cache.delete("users/#{@current_user.id}/orders")
    Rails.cache.write("orders/#{order.id}", order)

    OrderProcessingJob.perform_async(order.id)
    render json: { message: "Order placed successfully" }, status: :created
  end

  def update
    @order.update!(order_params)

    Rails.cache.delete("users/#{@current_user.id}/orders")
    Rails.cache.delete("orders/#{@order.id}")

    render json: { message: "Order updated successfully" }, status: :ok
  end

  def destroy
    @order.destroy

    Rails.cache.delete("users/#{@current_user.id}/orders")
    Rails.cache.delete("orders/#{@order.id}")

    head :no_content
  end

  private

  def set_order
    @order = Rails.cache.fetch("orders/#{params[:id]}", expires_in: 10.minutes) do
      Order.includes(order_items: :product).find(params[:id])
    end
  end

  def order_params
    params.require(:order).permit(
      :total_price,
      order_items_attributes: [ :product_id, :quantity ]
    )
  end

  def serialize_order(order)
    order.as_json(
      only: [ :id, :total_price ],
      methods: [ :user_name, :date ],
      include: {
        order_items: {
          only: [ :quantity ],
          methods: [ :product_name, :product_price ]
        }
      }
    )
  end
end
