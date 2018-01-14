module Rizal
	Kapital = [	' ', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
				'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S',
				'T', 'U', 'V', 'W', 'X', 'Y', 'Z'	]
	Biasa	= [	' ', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
				'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
				't', 'u', 'v', 'w', 'x', 'y', 'z'	]
	Tanda_B = [	' ', '.', ',', '?', '!', '(', ')', '@', ':', "\n",
				'<', '>', '"', '[', ']', '*', '#', '{', '}', '/',
				'<', '>', '"', '[', ']', '*', '#', '{', '}', '/',
				'_', '0', '$']
	class << self
		def parse(file)
			@file = file
			data = ''
			until @file.empty?
				value = @file.slice!(0, 1)
				value += @file.slice!(0, 1) until @file.slice(0, 1) == "/" || @file.empty?
				data += ubah_kode(value)
			end
			return final_parse(data)
		end

		def ke_kode(file)
			@file = kode_class_proses(file)
			data = ''
			data += ubah_kode(@file.slice!(0, 1)) until @file.empty?
			return data
		end

		def kode_class_proses(data)
			return 0 if data.nil?
			return '$nol$' if data == 0
			kelas = data.class
			kelas = kelas.superclass until kelas.superclass == Object
			return case kelas.to_s
			when 'String' ; data
			when 'Symbol' ; ':' + data.to_s
			when 'Numeric' ; data.to_s
			when 'Hash'
				hasil = []
				data.each do |k, v|
					hasil.push(kode_class_proses([k, v]))
				end
				'<' + '{' + hasil.join(',') + '}' + '>'
			when 'Array'
				data.each_with_index do |v, i|
					kelas = v.class
					kelas = kelas.superclass until kelas.superclass == Object
					value = kode_class_proses(v)
					data[i] = "#{value}(#{kelas})"
				end
				'<' + '[' + data.join(',') + ']' + '>'
			else
				hasil = ''
				hasil += '#<' + data.class.to_s + ':'
				data.instance_variables.each do |i|
					hasil += ' ' + '*' + i.to_s + ' '
					value = data.instance_variable_get(i)
					hasil += kode_class_proses(value).to_s + '*'
				end
				hasil += '>'
				return hasil
			end
		end
		
		def parse_pertama(data)
			return 0 if data == '$nol$'
			if data[0] == ':'
				data.slice!(0, 1)
				return :"#{data}"
			elsif data.to_i != 0
				return data.to_i
			elsif data[0, 2] == '<[' && data[-2, 2] == ']>'
				data.slice!(0, 2)
				data.slice!(-2, 2)
				index, gali, kalimat, ary = 0, 0, '', []
				until index >= data.size
					gali += 1 if data[index] == '<'
					gali -= 1 if data[index] == '>'
					kalimat += data[index]
					lengkap = (data[index] == ',' && gali < 1 && kalimat.include?('(') && kalimat.include?(')'))
					if index + 1 >= data.size || lengkap
						kalimat.slice!(-1, 1) if data[index] == ','
						ary.push(kalimat)
						kalimat = ''
					end
					index += 1
				end
				data = []
				ary.each do |i|
					kurung_buka = -(i.reverse.index('(') + 1)
					kurung_tutup = -(i.reverse.index(')') + 1)
					kelas = i.slice!(kurung_buka, kurung_tutup - kurung_buka + 1)
					kelas.slice!(0, 1)
					kelas.slice!(-1, 1)
					hasil = case kelas
					when 'Numeric' ; i.to_i
					when 'String' ; i
					when 'Symbol' ; :"#{i[1, i.size]}"
					else ; final_parse(i)
					end
					data.push(hasil)
				end
				return data
			elsif data[0, 2] == '<{' && data[-2, 2] == '}>'
				data.slice!(0, 2)
				data.slice!(-2, 2)
				index, gali, kalimat, has = 0, 0, '', {}
				until index >= data.size
					gali += 1 if data[index] == '<'
					gali -= 1 if data[index] == '>'
					kalimat += data[index]
					if index + 1 >= data.size || (data[index] == ',' && gali < 1)
						kalimat.slice!(-1, 1) if data[index] == ','
						has_element = final_parse(kalimat)
						has[has_element[0]] = has_element[1]
						kalimat = ''
					end
					index += 1
				end
				return has
			elsif !(data.include?('<') || data.include?('>'))
				return data
			end
			return nil
		end

		def final_parse(data)
			pertama = parse_pertama(data)
			return pertama unless pertama.nil?
			return data unless (data.include?('<') && data.include?('>'))
			data.slice!('#')
			kelas = const_get(data.slice!(data.index('<') + 1, data.index(':') - 1))
			if kelas == TrueClass
				return true
			elsif kelas == FalseClass
				return false
			else
				kelas = kelas.allocate
			end
			return kelas unless data.size > 3
			data.slice!('<:')
			data.slice!(-1, 1)
			instance = {}
			until data.scan('*').empty?
				key, value = '', ''
				data.slice!(0, 2)
				key += data.slice!(0, 1) until data[0, 1] == ' '
				data.slice!(0, 1)
				value += data.slice!(0, 1) until data[0, 1] == '*'
				data.slice!(0, 1)
				instance[:"#{key}"] = final_parse(value)
			end
			instance.each { |i, v| kelas.instance_variable_set(i, v)}
			kelas
		end

		def ubah_kode(char)
			char if char.nil?
			hasil = ''
			if char.include?('/?') && char[-1] == 'x'
				case char.scan('x').size
				when 1
					if char.include?('#')
						char.slice!(0, 3)
						char.slice!('x')
						hasil = Tanda_B[char.to_i]
					else
						char.slice!(0, 2)
						char.slice!('x')
						hasil = char
					end
				when 2
					char.slice!(0, 3)
					char.slice!('x')
					hasil = Biasa[char.to_i]
				when 3
					char.slice!(0, 4)
					char.slice!('x')
					hasil = Kapital[char.to_i]
				end
			else
				hasil += '/?'
				if char.to_i != 0 && char.to_i.is_a?(Integer)
					hasil += char.to_s
				elsif Biasa.include?(char)
					index = Biasa.index(char).to_s
					hasil += index[0, 1] + 'x' + index
				elsif Kapital.include?(char)
					index = Kapital.index(char).to_s
					hasil += index[0, 1] + 'x' + 'x' + index
				elsif Tanda_B.include?(char)
					index = Tanda_B.index(char).to_s
					hasil += '#' + index
				else ; hasil += '0'
				end
				hasil += 'x'
			end
			return hasil
		end
	end
end