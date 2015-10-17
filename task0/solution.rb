def convert_to_bgn(amount, currency)
  bgn_amount = case currency
                 when :usd then amount * 1.7408
                 when :eur then amount * 1.9557
                 when :gbp then amount * 2.6415
                 else amount
               end

  bgn_amount.round(2)
end

def compare_prices(first_price, first_currency, second_price, second_currency)
  first_price = convert_to_bgn(first_price, first_currency)
  second_price = convert_to_bgn(second_price, second_currency)

  first_price <=> second_price
end
