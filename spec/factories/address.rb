FactoryBot.define do
  factory :address do
    postcode { Faker::Number.number(digits: 7) }
    address { Gimei.address.kanji }
    dear { Gimei::Name.new }
  end
end