FactoryBot.define do
  factory :cart_item do
    product { nil }
    cart { nil }
    quantity { 1 }
  end
end
