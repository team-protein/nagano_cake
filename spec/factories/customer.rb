FactoryBot.define do
  factory :customer do
    last_name { "hoge" }
    first_name { "hoge" }
    last_name_kana { "hoge" }
    first_name_kana { "hoge" }
    phone_number { Faker::PhoneNumber }
    postcode { "0000000" }
    address { Faker::Address.full_address }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end