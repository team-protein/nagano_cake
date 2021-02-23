# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(email: 'test@gmail.com',
              password: 'testpass')

25.times do |number|
  gimei = Gimei::Name.new
  Customer.create!(email: "test#{number}@test.com",
                   password: 'password',
                   password_confirmation: 'password',
                   last_name: gimei.last.kanji,
                   first_name: gimei.first.kanji,
                   last_name_kana: gimei.last.katakana,
                   first_name_kana: gimei.first.katakana,
                   phone_number: Faker::PhoneNumber.phone_number,
                   postcode: Faker::Number.number(digits: 7),
                   address: Gimei.address.kanji,
                   is_deleted: false)
end

Genre.create!(name: 'ケーキ')
Genre.create!(name: 'プリン')
Genre.create!(name: '焼き菓子')
Genre.create!(name: 'キャンディ')

15.times do |number|
  Product.create!(genre_id: 1,
                  name: "ケーキ#{number}",
                  description: number,
                  price: 4000,
                  is_active: true,
                  conversion_name: "けーき#{number}")
end

8.times do |number|
  Product.create!(genre_id: 1,
                  name: "ケーキ#{number}(売り切れ)",
                  description: number,
                  price: 2500,
                  is_active: false,
                  conversion_name: "けーき#{number}")
end

5.times do |number|
  Product.create!(genre_id: 2,
                  name: "プリン#{number}",
                  description: number,
                  price: 400,
                  is_active: true,
                  conversion_name: "ぷりん#{number}")
end

10.times do |number|
  Product.create!(genre_id: 2,
                  name: "プリン#{number}(売り切れ)",
                  description: number,
                  price: 500,
                  is_active: false,
                  conversion_name: "ぷりん#{number}")
end

13.times do |number|
  Product.create!(genre_id: 3,
                  name: "焼き菓子",
                  description: number,
                  price: 320,
                  is_active: true,
                  conversion_name: "やきがし")
end

7.times do |number|
  Product.create!(genre_id: 3,
                  name: "焼き菓子",
                  description: number,
                  price: 590,
                  is_active: false,
                  conversion_name: "やきがし")
end

3.times do |number|
  Product.create!(genre_id: 4,
                  name: "キャンディ#{number}",
                  description: number,
                  price: 350,
                  is_active: true,
                  conversion_name: "きゃんでぃ#{number}")
end

2.times do |number|
  Product.create!(genre_id: 4,
                  name: "キャンディ#{number}(売り切れ)",
                  description: number,
                  price: 340,
                  is_active: false,
                  conversion_name: "きゃんでぃ#{number}")
end



100.times do |number|
  Order.create!(customer_id: 1,
                postcode: "1234567",
                address: "test",
                dear: "test",
                total_price: rand(1000..10000),
                shipping_cost: 800,
                created_at: "2021-#{rand(1..12)}-#{rand(1..28)} 04:39:22")
end