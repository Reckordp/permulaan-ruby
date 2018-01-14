def cek_compress(teks)
	def ekstrak_data(kunci)
		data1 = "abcdefghijklmnopqrstuvwxyz"
		data2 = "1234567890!@$%^&*()=_"
		data3 = ",./;'[]`<>?{}~+ "

		tingkatan = data1.upcase + data1.downcase + data2 + data3
		data = tingkatan.dup
		data.size.times do |i|
			pecahan = data.slice!(i)
			i = i % 2 == 0 ? i + kunci : i - kunci
			i %= data.size
			data.insert(i, pecahan)
		end
		def data.[](index)
			index %= self.size
			super(index)
		end

		return data
	end

	hasil_zip = ""

	def compress(data, teks)
		hasil_zip = ""
		until teks < data.size
			jumlah = teks / data.size - 1
			if jumlah / data.size != 0
				cmp = jumlah / data.size - 1
				hasil_zip += compress(data, cmp)
			end
			hasil_zip += data[jumlah]
			nilai = data.size * (jumlah + 1)
			teks -= nilai
		end
		hasil_zip += data[teks] if data[teks]
		return hasil_zip
	end

	def faktorial(angka)
		Array.new(angka) { |i| i + 1 } .inject(1) { |hasil, nilai| hasil *= nilai }
	end

	def unfaktorial(angka)
		n = 1
		until angka / n < 1
			angka /= n
			n += 1
		end
		return n - 1
	end

	def rumus(m, n, o)
		return m ** n + faktorial(o)
	end

	def kompres_angka(angka, max)
		s = []
		until unfaktorial(angka) < 6
			s.push("%02d" % unfaktorial(angka))
			angka -= faktorial(unfaktorial(angka))
		end
		p t = s.uniq.collect { |i| i.to_s + s.find_all { |ii| i == ii }.size.to_s } .join
		# n = 1
		# o = unfaktorial(angka)
		# hasil = 0
		# return angka if angka < max
		# until angka - rumus(hasil, n, o) < max
		# 	hasil += 1
		# 	if hasil > max - 1
		# 		n += 1
		# 		hasil = 0
		# 	elsif n > max - 1
		# 		hasil = 1
		# 		n = 1
		# 	end
		# end
		# hasil -= 1 if rumus(hasil, n, o) > angka
		# angka -= rumus(hasil, n, o)
		# angka += 1
		# kompres = angka.to_s + ("%02d" % hasil.to_s) + ("%02d" % n.to_s) + ("%02d" % o.to_s)
		# p [hasil, n, o, rumus(hasil, n, o), kompres]

		return p "#{angka}-#{t}"
	end

	def kecilkan(teks)
		kalimat = teks.is_a?(String)
		terbagi = 1
		kunci = rand(ekstrak_data(0).size)
		if kalimat
			teks.gsub!(/\:/) { |match| "+-" }
			teks.gsub!(/\-/) { |match| "++" }
			data = ekstrak_data(kunci)
			teks = teks.each_char.map { |v, i| data.index(v) }
			teks.collect! { |i| "%02d" % (i + 1) }
			teks = teks.join.to_i
		end
		data = ekstrak_data(kunci)
		hasil = kompres_angka(teks, data.size).split(/\-/).inject("") { |hasil, nilai| hasil += compress(data, nilai.to_i) + "-"}
		hasil.slice!(-1, 1)
		posisi_kunci = rand(hasil.size) + 1
		hasil.insert(kalimat ? 0 : posisi_kunci, ":#{compress(ekstrak_data(50), kunci)}")
		bytes = "".encode!("BINARY")
		hasil.each_byte { |i| bytes << i - 32 }
		return bytes
	end

	hasil_zip = kecilkan(teks)

	def uncompress(data, hasil_zip)
		unzip = 0
		until hasil_zip.empty?
			pecahan = hasil_zip.slice!(0, 1)
			i = data.index(pecahan)
			i = ( i + 1 ) * (data.size ** hasil_zip.size) unless hasil_zip.empty?
			unzip += i
		end
		return unzip
	end
	
	def bagi(teks, dibagi)
		teks = teks.dup
		hasil_bagi = []
		hasil_bagi.push(teks.slice!(0, dibagi)) until teks.empty?
		return hasil_bagi
	end

	def uncompress_angka(angka)
		return angka unless angka.to_s =~ /(.+)\-(.+)\-/
		fakt = []
		if $2.size % 3 != 0
			a = $2.slice!(0, $2.size % 3)
			b = a.slice!(-1, 1)
			[a] * 1
		end
		fakt += bagi($2, 2)
		return fakt.inject($1.to_i) { |hasil, nilai| hasil += faktorial(nilai.to_i) }
	end

	def keluarkan(teks_byte)
		teks = "".encode!("BINARY")
		teks_byte.each_byte { |i| teks << i + 32 }
		teks =~ /(:.)/
		kalimat = teks[0] == ":"
		teks.slice!($1)
		kunci = uncompress(ekstrak_data(50), $1[1, $1.size - 1])
		terbagi = 0
		data = ekstrak_data(kunci)
		hasil = uncompress_angka(teks.split(/\-/).inject("") { |hasil, nilai| hasil += uncompress(data, nilai).to_s + "-" })
		if kalimat
			hasil = hasil.to_s
			nomor = hasil.size % 2 == 0 ? [] : [hasil.slice!(0, 1)]
			nomor += bagi(hasil, 2)
			data = ekstrak_data(kunci)
			hasil = nomor.collect { |i| data[i.to_i - 1] } .join
			hasil.gsub!(/\+\+/) { "-" }
			hasil.gsub(/\+\+\+/) { ":" }
		end
		return hasil
	end

	return [hasil_zip, keluarkan(hasil_zip.dup)]
end

# nilai = "AAAAAAAAAAAAAAAA"
# p cek_compress(nilai)
def unfaktorial(angka)
	n = 1
	until angka / n < 1
		angka /= n
		n += 1
	end
	return n - 1
end

def faktorial(angka)
	Array.new(angka) { |i| i + 1 } .inject(1) { |hasil, nilai| hasil *= nilai }
end

def pola(angka)
	Array.new(angka) { |i| i + 1 } .inject(1) { |hasil, nilai| hasil += nilai }
end

nilai = 1000000000 * 9000
i = 1
kom = faktorial(i)

until kom > nilai
	i += 1
	kom += pola(i)
end

# i = 1
# until nilai >= kom
# 	kom -= pola(i)
# 	i += 1
# end

p [kom, nilai, i]