FactoryBot.define do
  factory :product do
    name { Faker::Lorem.characters(number:5) }
    description { Faker::Lorem.characters(number:50) }
    price { rand(500..1000) }
    is_active { "true" }
    genre 
  end
end