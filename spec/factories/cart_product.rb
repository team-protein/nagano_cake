FactoryBot.define do
  factory :cart_product do
    quantity { rand(1..99) }
    customer
    product
  end
end