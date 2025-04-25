class Api::V1::CartsController < ApplicationController
  before_action :set_cart
  before_action :set_product, only: [ :update ]
  before_action :set_cart_item, only: [ :destroy ]

  def show
    render json: serialize_cart(@cart)
  end

  def update
    item = @cart.cart_items.find_or_create_by(product: @product)
    item.quantity ||= 0
    item.quantity += params[:quantity].to_i
    item.save!
    render json: { "message": "Product added to Cart successfully" }, status: :ok
  end

  def destroy
    @cart_item.destroy
    head :no_content
  end

  private

  def set_cart
    @cart = @current_user.cart.includes(cart_items: :product)
  end

  def set_product
    @product = Product.find_by(id: params[:product_id])
  end

  def set_cart_item
    @cart_item = @cart.cart_items.find_by(product_id: params[:product_id])
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
