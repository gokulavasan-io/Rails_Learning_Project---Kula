FactoryBot.define do
  factory :order do
    user
    total_price { 100.0 }
  end
end