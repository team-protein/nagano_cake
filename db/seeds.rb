# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(email: ENV['ADMIN_EMAIL'],
             password: ENV['ADMIN_PASSWORD'])

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
                  conversion_name: "keki")
end

8.times do |number|
  Product.create!(genre_id: 1,
                  name: "ケーキ#{number}",
                  description: number,
                  price: 2500,
                  is_active: false,
                  conversion_name: "keki")
end

5.times do |number|
  Product.create!(genre_id: 2,
                  name: "プリン#{number}",
                  description: number,
                  price: 400,
                  is_active: true,
                  conversion_name: "purin")
end

10.times do |number|
  Product.create!(genre_id: 2,
                  name: "プリン#{number}",
                  description: number,
                  price: 500,
                  is_active: false,
                  conversion_name: "purin")
end

13.times do |number|
  Product.create!(genre_id: 3,
                  name: "焼き菓子",
                  description: number,
                  price: 320,
                  is_active: true,
                  conversion_name: "yakigashi")
end

7.times do |number|
  Product.create!(genre_id: 3,
                  name: "焼き菓子",
                  description: number,
                  price: 590,
                  is_active: false,
                  conversion_name: "yakigashi")
end

3.times do |number|
  Product.create!(genre_id: 4,
                  name: "キャンディ#{number}",
                  description: number,
                  price: 350,
                  is_active: true,
                  conversion_name: "kinde")
end

2.times do |number|
  Product.create!(genre_id: 4,
                  name: "キャンディ#{number}",
                  description: number,
                  price: 340,
                  is_active: false,
                  conversion_name: "kinde")
end

Customer.create!(email: "test@gmail.com",
                  password: "testpass",
                  last_name: "test",
                  first_name: "test", 
                  last_name_kana: "test", 
                  first_name_kana: "test",
                  phone_number: 1234,
                  postcode: "1234567",
                  address: "test"
                )

100.times do |number|
  Order.create!(customer_id: 1,
                postcode: "1234567",
                address: "test",
                dear: "test",
                total_price: rand(1000..10000),
                shipping_cost: 800,
                created_at: "2021-#{rand(1..12)}-#{rand(1..28)} 04:39:22")
end