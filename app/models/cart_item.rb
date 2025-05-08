class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 1}

  def product_name
    product.name
  end

  def product_price
    product.price
  end

end
