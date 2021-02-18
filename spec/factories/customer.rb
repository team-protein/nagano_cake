FactoryBot.define do
  factory :customer do
    gimei = Gimei::Name.new
    last_name { gimei.last.kanji }
    first_name { gimei.first.kanji }
    last_name_kana { gimei.last.katakana }
    first_name_kana { gimei.first.katakana }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    postcode { Faker::Number.number(digits: 7) }
    address { Gimei.address.kanji }
    is_deleted { "false" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end