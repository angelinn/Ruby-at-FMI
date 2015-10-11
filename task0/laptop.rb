def convert_to_bgn(amount, currency)
	result = 0

	case currency
		when :usd
			result = amount * 1.7408
		when :eur
			result = amount * 1.9557
		when :gbp
			result = amount * 2.6415
	end

	result.round(2)
end

def compare_prices(first, f_currency, second, s_currency)
	if (f_currency != :bgn)
		first = convert_to_bgn(first, f_currency)
	end
	if (s_currency != :bgn)
		second = convert_to_bgn(second, s_currency)
	end

	first <=> second
end

puts compare_prices(100, :usd, 100, :bgn)