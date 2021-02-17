module ApplicationHelper
  # 税抜価格に三桁区切りのカンマを入れる
  def tax_excluded_price(price)
    price = price.floor
    "#{price.to_s(:delimited, delimiter: ',')}"
  end

  # 税込価格に三桁区切りのカンマを入れる
  def tax_included_price(price)
    price = price*1.1
    price = price.floor
    "#{price.to_s(:delimited, delimiter: ',')}"
  end

  # 税込の単価に数量を掛け、三桁区切りのカンマを入れる
  def subtotal_price(price, quantity)
    price = price*1.1
    price = price.floor
    price = price*quantity
    "#{price.to_s(:delimited, delimiter: ',')}"
  end

end
