def akar(angka)
	n = 0
	asal = 1
	while n <= angka
		asal = 0.5 * ( asal + ( angka / asal ) )
		n += 1
	end
	return asal
end