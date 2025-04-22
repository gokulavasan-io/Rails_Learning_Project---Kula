class Api::V1::CartsController < ApplicationController
  def show
    cart = @current_user.cart
    render json: cart.as_json(include: { cart_items: { include: :product } })
  end

  def add_item
    cart = @current_user.cart
    product = Product.find(params[:product_id])
      item = cart.cart_items.find_or_initialize_by(product: product)
      item.quantity ||= 0
      item.quantity += params[:quantity].to_i
      item.save!
      render json: { product_id: product.id, quantity: params[:quantity] }, status: :ok
  rescue ActiveRecord::RecordNotFound
      render json: { error: 'Product not found' }, status: :not_found
  end

  def remove_item
    cart_item = @current_user.cart.cart_items.find_by!(product_id: params[:product_id])
    cart_item.destroy
    render json: { message: 'Item removed' }, status: :ok
  rescue ActiveRecord::RecordNotFound
      render json: { error: 'Item not found' }, status: :not_found
  end
end
