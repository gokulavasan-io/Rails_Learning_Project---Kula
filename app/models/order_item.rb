class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def product_price
      product.price
  end

  def product_name
      product.name
  end

end
