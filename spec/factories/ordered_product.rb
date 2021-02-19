FactoryBot.define do
  factory :ordered_product do
    quantity { rand(1..99) }
    tax_included_price { rand(1000..9999) }
  end
end