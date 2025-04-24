class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy

  after_create :create_cart

  def create_cart
    Cart.create(user: self)
  end

end
