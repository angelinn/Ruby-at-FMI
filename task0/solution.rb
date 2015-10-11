def convert_to_bgn(amount, currency)
  result = case currency
             when :usd
              amount * 1.7408
             when :eur
              amount * 1.9557
             when :gbp
              amount * 2.6415
           end

  result.round(2)
end

def compare_prices(first, f_currency, second, s_currency)
  first = convert_to_bgn(first, f_currency) unless f_currency == :bgn
  second = convert_to_bgn(second, s_currency) unless s_currency == :bgn

  first <=> second
end
