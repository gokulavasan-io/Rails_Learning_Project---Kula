class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  accepts_nested_attributes_for :order_items

  validates :total_price, presence: true

  def user_name
      user.name
  end
  
  def date
    created_at.strftime('%Y-%m-%d')
  end

end
