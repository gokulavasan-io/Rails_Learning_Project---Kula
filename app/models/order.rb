class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  def user_name
      user.name
  end
  
  def date
    created_at.strftime('%Y-%m-%d')
  end

end
