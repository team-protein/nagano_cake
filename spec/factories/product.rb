FactoryBot.define do
  factory :product do
    name { Faker::Lorem.characters(number:5) }
    description { Faker::Lorem.characters(number:50) }
    price { Faker::Number.number(4) }
    is_active { Faker::Boolean.boolean }
    genre
  end
end