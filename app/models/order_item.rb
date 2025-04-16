class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def product_name
    product.name
  end

  def product_price
    product.price
  end


end
