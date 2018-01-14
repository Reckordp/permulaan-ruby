def panjang_dari(derajat)
	derajat %= 360

	x = 0
	y = 0

	if derajat <= 90
		y = derajat <= 45 ? 1.0 : 1.0 - (derajat / 2.0) * (1.0 / 45)
		x = derajat <= 45 ? derajat * (1.0 / 45) : 1.0
	elsif derajat <= 180
		derajat = (derajat - 180).abs
		y = derajat <= 45 ? 1.0 : 1.0 - (derajat / 2.0) * (1.0 / 45)
		x = derajat <= 45 ? derajat * (1.0 / 45) : 1.0
		y *= -1
	elsif derajat <= 270
		derajat -= 180
		y = derajat <= 45 ? 1.0 : 1.0 - (derajat / 2.0) * (1.0 / 45)
		x = derajat <= 45 ? derajat * (1.0 / 45) : 1.0
		x *= -1
		y *= -1
	else
		derajat = (derajat - 360).abs
		y = derajat <= 45 ? 1.0 : 1.0 - (derajat / 2.0) * (1.0 / 45)
		x = derajat <= 45 ? derajat * (1.0 / 45) : 1.0
		x *= -1
	end

	return [x, y]
end

p panjang_dari(44)