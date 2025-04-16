class Api::V1::ProductsController < ApplicationController
      def index
        products = Product.all
        render json: serialize_product(products)
      end

      def show
        product = Product.find(params[:id])
        render json: serialize_product(product)
      end

      def create
        product = Product.new(product_params)
        if product.save
          render json: serialize_product(product), status: :created
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end


      def update
        product = Product.find(params[:id])
        if product.update(product_params)
          render json: serialize_product(product)
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        product = Product.find(params[:id])
        product.destroy
        head :no_content
      end

      private


      def product_params
        params.require(:product).permit(:name, :description, :price)
      end

      def serialize_product(product)
        product.as_json(only: [:id, :name, :price, :description])
      end
end
