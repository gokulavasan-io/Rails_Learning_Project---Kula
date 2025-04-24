class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  def product_name
    product.name
  end

  def product_price
    product.price
  end

end
