FactoryBot.define do
  factory :product do
    name { "Sample Product" }
    description { "A description of the product" }
    price { 10.0 }
  end
end
