FactoryBot.define do
  factory :order do
    postcode { "0000000" }
    address { Faker::Address.full_address }
    dear { Faker::Name.name }
    total_price { rand(1000..9999) }
    shipping_cost { 800 }
    payment_method { rand(0..1) }
    status { 0 }
  end
end