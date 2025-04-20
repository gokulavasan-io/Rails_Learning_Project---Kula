class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :order, presence: true
  validates :product, presence: true
  validates :quantity, presence: true


  def product_name
    product.name
  end

  def product_price
    product.price
  end


end
