module ApplicationHelper
  # 税抜価格に三桁区切りのカンマを入れる
  def tax_excluded_price(price)
    price = price.floor
    "#{price.to_s(:delimited, delimiter: ',')}円"
  end

  # 税込価格に三桁区切りのカンマを入れる
  def tax_included_price(price)
    price = price*1.08
    price = price.floor
    "#{price.to_s(:delimited, delimiter: ',')}円"
  end
end
