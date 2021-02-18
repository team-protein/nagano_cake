FactoryBot.define do
  factory :cart_product do
    quantity { Faker::Number.number(1) }
    customer
    product
  end
end