class Api::V1::CartsController < ApplicationController
  before_action :set_cart
  before_action :set_product, only: [ :create ]
  before_action :set_cart_item, only: [ :update, :destroy ]

  def show
    render json: serialize_cart(@cart)
  end

  def create
    item = @cart.cart_items.find_or_initialize_by(product: @product)
    item.quantity = (item.quantity || 0) + params[:quantity].to_i
    item.save!
    render json: { "message": "Product added to Cart successfully" }, status: :created
  end

  def update
    @cart_item.quantity = params[:quantity].to_i
    @cart_item.save!
    render json: { "message": "Cart Updated successfully" }, status: :ok
  end

  def destroy
    @cart_item.destroy
    head :no_content
  end

  private

  def set_cart
    @cart = Cart.includes(cart_items: :product).find_by(user_id: @current_user.id)
  end

  def set_product
    @product = Rails.cache.fetch("products/#{params[:id]}", expires_in: 10.minutes) do
      Product.find(params[:id])
    end
  end

  def set_cart_item
    @cart_item = @cart.cart_items.find { |item| item.product_id == params[:product_id].to_i }
    raise ActiveRecord::RecordNotFound unless @cart_item
  end

  def serialize_cart(cart)
    cart.cart_items.map do |item|
      {
        quantity: item.quantity,
        product_name: item.product_name,
        product_price: item.product_price
      }
    end
  end
end
