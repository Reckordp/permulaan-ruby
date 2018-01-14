class Aljabar
	class Suku
		attr_reader :operasi, :konstanta, :variabel
		def initialize(bentuk)
			@operasi = bentuk.slice!(/\-/) ? :negatif : :positif
			@konstanta = bentuk.slice!(/[\d]+/).to_i
			@variabel = bentuk.slice!(/[a-z\/]+/) || ""
			@konstanta = 1 if @konstanta == 0 && !@variabel.empty?
			@konstanta *= -1 if @operasi == :negatif
		end

		def variabel_negatif
			var = variabel.clone.split(//).collect.with_index { |nilai, indeks| variabel[indeks - 1] == "/" ? "/" + nilai : nilai }
			var.keep_if { |nilai| nilai =~ /\/[a-z]/ }
			return var
		end

		def variabel_positif
			var = variabel.clone.split(//).collect.with_index { |nilai, indeks| variabel[indeks - 1] == "/" ? "/" + nilai : nilai }
			var.reject! { |nilai| nilai =~ /\/[a-z]*/ }
			return var
		end

		def nol?
			return @konstanta == 0
		end

		def <=>(lain)
			return 1 if @konstanta < 0
			return -1 if lain.konstanta < 0
			return 1 if @variabel.empty?
			return -1 if lain.variabel.empty?
			return 0 if @variabel == lain.variabel
			return -1 if @variabel < lain.variabel
			return 1
		end

		def sejenis?(lain)
			return true if nol? || lain.nol?
			return false unless lain.is_a?(Suku)
			lain.variabel == @variabel
		end

		def >(lain)
			return @konstanta > lain.konstanta
		end

		def <(lain)
			return @konstanta < lain.konstanta
		end

		def +(lain)
			return nil unless sejenis?(lain)
			hasil_konstanta = @konstanta + lain.konstanta
			return Suku.new("0") if hasil_konstanta == 0
			return Suku.new(hasil_konstanta.to_s + lain.variabel) if nol?
			return Suku.new(hasil_konstanta.to_s + @variabel)
		end

		def -(lain)
			self.+(lain * -1)
		end

		def *(lain)
			return nil unless lain.is_a?(Fixnum) || lain.is_a?(Suku)
			return Suku.new((konstanta * lain).to_s + variabel) if lain.is_a?(Fixnum)
			negatif = (variabel_negatif + lain.variabel_negatif).collect { |nilai| nilai.slice!(/\//); nilai } .sort
			var = (variabel_positif + lain.variabel_positif).sort
			var.dup.each { |nilai| (negatif.delete_at(negatif.index(nilai)) ; var.delete_at(var.index(nilai))) if negatif.include?(nilai) }
			var += negatif.collect { |nilai| "/" + nilai }
			return Suku.new((konstanta * lain.konstanta).to_s + var.join)
		end

		def /(lain)
			return Suku.new((@konstanta / lain).to_s + @variabel) if lain.is_a?(Fixnum)
			return unless lain.is_a?(Suku)
			positif = lain.variabel_negatif.collect { |nilai| nilai.slice!(/\//); nilai } .sort
			negatif = lain.variabel_positif.sort.collect { |nilai| "/" + nilai }
			hasil_kali = self.*(Suku.new("1" + positif.join + negatif.join))
			konstanta = @konstanta / lain.konstanta
			return Suku.new("0") if konstanta == 0
			return Suku.new(konstanta.to_s + hasil_kali.variabel)
		end

		def inspect
			return (@konstanta.to_s || "") +  + @variabel
		end

		def to_s
			return (@konstanta.to_s || "") + @variabel
		end
	end

	def initialize(bentuk)
		format = bentuk.to_s
		format.slice!(/[ ]+/) if format[0] == " "
		format.insert(0, "+") if format[0] !~ /[\+\-\(]/
		format.gsub!(/\+ [\da-z]/) 	{ |match| "+" + match.match(/[\da-z]/)[0] }
		format.gsub!(/\- [\da-z]/) 	{ |match| "-" + match.match(/[\da-z]/)[0] }
		format.gsub!(/\([^\)]+\)/) 	{ |match| Aljabar(match[1, match.size - 2]).inspect }
		format.gsub!(/[\+\-\da-z\/]+ [\*\.] [\+\-\da-z\/]+/) do |m|
			(Suku.new(m.slice!(/[\+\-\da-z\/]+/)) * Suku.new(m.slice!(/[\+\-\da-z\/]+/))).inspect
		end
		format.gsub!(/[\+\-\da-z\/]+ [\/\:] [\+\-\da-z\/]+/) do |m|
			pertama = Suku.new(m.slice!(/[\+\-\da-z\/]+/))
			m.slice!(/[\/\:]/)
			kedua = Suku.new(m.slice!(/[\+\-\da-z\/]+/))
			(pertama / kedua).inspect
		end
		@nilai = format.split(/ /).collect { |nilai| Suku.new(nilai) }.sort
		@nilai = self.+(Aljabar("0")).suku1.clone if koefesien.any? { |indeks, nilai| nilai.size > 1 }
		@nilai.reject! { |nilai| nilai.nol? } if @nilai.size > 1
	end

	def koreksi_operasi(bentuk_aljabar)
		bentuk_aljabar.slice!(0, bentuk_aljabar =~ /[\da-z\/]/) if bentuk_aljabar[0] == "+"
		bentuk_aljabar.gsub!(/\+\-[a-z\d]/) 	{ |m| "- " + m.match(/[a-z\d]/)[0] }
		bentuk_aljabar.gsub!(/\+[a-z\d]/) 		{ |m| "+ " + m.match(/[a-z\d]/)[0] }
		bentuk_aljabar.gsub!(/\-[a-z\d]/)		{ |m| "- " + m.match(/[a-z\d]/)[0] }
		bentuk_aljabar[0, 2] = "-" if bentuk_aljabar[0, 3] =~ /\- [a-z\d]/
		return bentuk_aljabar
	end

	def [](indeks)
		return suku1[indeks]
	end

	def []=(indeks, nilai)
		if nilai.is_a?(Fixnum)
			@nilai[indeks] = nilai
			@nilai = Aljabar(inspect).suku1.clone.compact.sort!
			return self
		end
		return nil unless nilai.is_a?(Aljabar)
		@nilai[indeks, nilai.suku1.size] = nilai.suku1
		@nilai = Aljabar(inspect).suku1.clone.compact.sort!
		return self
	end

	def suku1
		return @nilai.clone
	end

	def suku2
		bentuk = @nilai
		dua_suku = bentuk.collect.with_index do |nilai, indeks|
			indeks == 0 ? next : koreksi_operasi(bentuk[indeks - 1].to_s + " +" + nilai.inspect)
		end
		return dua_suku.compact
	end

	def variabel
		return @nilai.collect { |nilai| nilai.variabel } .uniq
	end

	def konstanta
		return @nilai.collect { |nilai| nilai.konstanta }
	end

	def koefesien(konstanta = nil)
		d = {}
		v = variabel
		konstanta ? d[konstanta] = [] : v.each { |i| d[i] = [] }
		@nilai.each { |nilai| d[nilai.variabel].push(nilai.konstanta) }
		return d
	end

	def inspect
		return koreksi_operasi(@nilai.collect { |nilai| nilai.to_s } .join(" +").clone)
	end

	def *(lain)
		case lain
		when Fixnum
			faktor = koefesien
			faktor.each_key { |indeks| faktor[indeks].map! { |nilai| (nilai.to_i * lain).to_s } }
			suku = faktor.values.collect.with_index { |nilai, indeks| as = faktor.keys[indeks] ; nilai.collect { |i| i + as } }
			bentuk = suku.collect { |nilai| nilai.join }.join(" +")
			return Aljabar(koreksi_operasi(bentuk))
		when Aljabar
			perkalian = []
			suku1.each { |nilai| lain.suku1.each { |suku_lain| perkalian.push(nilai * suku_lain) } }
			hasil = perkalian.join(" +")
			return Aljabar(koreksi_operasi(hasil))
		end
		return nil
	end

	def /(lain)
		return Aljabar( suku1.collect { |n| n / lain } ) if lain.is_a?(Fixnum)
		return unless lain.is_a?(Aljabar)
		hasil = suku1.collect { |nilai| lain.suku1.inject(nilai) { |hasil, nilai| hasil /= nilai } }
		hasil.reject! { |nilai| nilai.nol? } if hasil.size > 1
		return Aljabar(koreksi_operasi(hasil.join(" +")))
	end

	def +(lain)
		return nil unless lain.is_a?(Aljabar)
		k = koefesien
		lain.koefesien.each { |indeks, nilai| k[indeks] ||= [] ; k[indeks] += nilai }
		k.each do |ki, nilai|
			nilai.each_with_index do |ii, i|
				next k[ki] = Suku.new(ii.to_s + ki) if i == 0
				k[ki] += Suku.new(ii.to_s + ki)
			end
		end
		k.delete_if { |nilai| k[nilai].nol? }
		return Aljabar("0") if k.empty?
		hasil = k.values.join(" +")
		hasil.slice!(0, 1) if hasil[0] == "+"
		koreksi_operasi(hasil)
		return Aljabar(hasil)
	end

	def -(lain)
		return self.+(lain * -1)
	end

	def sama_dengan(lain)
		return unless lain.is_a?(Aljabar)
		(variabel + lain.variabel).uniq.each do |variabel|
			s = Aljabar(inspect)
			l = Aljabar(lain.inspect)
			s.suku1.select { |nilai| nilai.variabel != variabel } .each do |nilai|
				s -= Aljabar(nilai)
				l -= Aljabar(nilai)
			end
			l.suku1.select { |nilai| nilai.variabel == variabel } .each do |nilai|
				s -= Aljabar(nilai)
				l -= Aljabar(nilai)
			end
			if s.konstanta.any? { |nilai| nilai < 0 }
				s *= -1
				l *= -1
			end
			bagi = fpb( *(s.konstanta + l.konstanta).collect { |nilai| nilai.abs } )
			s /= bagi
			l /= bagi
			puts s.inspect + " = " + l.inspect
		end
		return nil
	end
end

module Kernel
	def Aljabar(format)
		Aljabar.new(format)
	end

	def fpb(*args)
		return nil unless args.all? { |nilai| nilai.is_a?(Fixnum) }
		return Array.new(args.min) { |nilai| args.min - nilai } .find { |nilai| args.all? { |n| n % nilai == 0 } }
	end
end

a = Aljabar("3x")
p a + Aljabar("12a")