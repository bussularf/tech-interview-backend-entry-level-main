FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    price { 10.0 }
  end
end
