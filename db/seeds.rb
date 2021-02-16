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
                  is_active: true)
end

10.times do |number|
  Product.create!(genre_id: 2,
                  name: "プリン#{number}",
                  description: number,
                  price: 500,
                  is_active: false)
end
