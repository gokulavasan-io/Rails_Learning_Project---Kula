class Api::V1::ProductsController < ApplicationController
      before_action :set_product, only: [ :show, :update, :destroy ]

      def index
        products = Product.all
        render json: serialize_product(products)
      end

      def show
        render json: serialize_product(@product)
      end

      def create
        product = Product.new(product_params)
        product.save!
        render json: serialize_product(product), status: :created
      end

      def update
        @product.update!(product_params)
        render json: serialize_product(@product)
      end

      def destroy
        @product.destroy
        head :no_content
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:name, :description, :price)
      end

      def serialize_product(product)
        product.as_json(only: [ :id, :name, :price, :description ])
      end
end
