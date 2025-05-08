class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: [ :show, :update, :destroy ]

  def index
    products = Rails.cache.fetch("products/index", expires_in: 10.minutes) do
      Product.all.to_a
    end
    render json: serialize_product(products)
  end

  def show
    render json: serialize_product(@product)
  end

  def create
    product = Product.new(product_params)
    product.save!

    Rails.cache.delete("products/index")
    render json: serialize_product(product), status: :created
  end

  def update
    @product.update!(product_params)

    Rails.cache.delete("products/index")
    Rails.cache.delete("products/#{@product.id}")
    render json: serialize_product(@product)
  end

  def destroy
    @product.destroy

    Rails.cache.delete("products/index")
    Rails.cache.delete("products/#{@product.id}")
    head :no_content
  end

  private

  def set_product
    @product = Rails.cache.fetch("products/#{params[:id]}", expires_in: 10.minutes) do
      Product.find(params[:id])
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :price)
  end

  def serialize_product(product)
    product.as_json(only: [ :id, :name, :price, :description ])
  end
end
