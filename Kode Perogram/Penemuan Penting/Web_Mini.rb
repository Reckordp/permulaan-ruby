require "socket"

class String
	def byteslice(args)
		e = encoding
		self.dup.force_encoding(Encoding::ASCII_8BIT).slice(args).force_encoding(e)
	end
end


class WebServer
	NAMA_UMUM = "127.0.0.1"
	PORT_UMUM = 80

	attr_reader :folder_utama

	def initialize(nama=NAMA_UMUM, port=PORT_UMUM)
		@alamat = {}
		@alamat[:IP] = nama
		@alamat[:PORT] = port
		@server = nil
		@client = []
		@folder_utama = ""
	end

	def folder_utama=(folder)
		return unless Dir.exist?(folder)
		folder += "/" if folder[-1] != "/"
		@folder_utama = folder
	end

	def mulai
		return unless Dir.exist?(@folder_utama)
		# return unless Socket.ip_address_list.include?(@alamat[:IP])
		return unless File.exist?(@folder_utama + "index.html")
		mulai_langsung
	end

	def mulai_langsung
		buat_server
		cek_client
		tutup_server
	end

	def buat_server
		@server = TCPServer.new(*@alamat.values)
		puts "Server #{@alamat[:IP]} :#{@alamat[:PORT]} sedang berjalan"
	end

	def tutup_server
		@server.close
	end

	def waktu_menunggu
		return 10.0
	end

	def cek_client
		loop do
			begin
				client_aktif = temukan_client
				if IO.select(@client.collect { |i| i.io }, nil, nil, waktu_menunggu)
					aksi_client(client_aktif)
				else
					puts "Waktu Habis"
				end
			rescue Errno::EPIPE, Errno::ECONNRESET
				puts "Pembatalan Koneksi"
				@client.delete(client_aktif.tutup)
			rescue
				a = $!
				print a.class.to_s + ": "
				puts a.message
				puts a.backtrace[0]
				return system "pause"
			end
		end
	end

	def file_utama(folder)
		folder = folder.clone
		folder += "/" if folder[-1] != "/"
		file = folder + "index.html"
		return file
	end

	def temukan_client
		@client << c = Tambahan::Client.new(@server, @server.accept)
		puts "Client Ditemukan"
		return c
	end

	def aksi_client(client_aktif)
		cek_permintaan(client_aktif.io, client_aktif)
		@client.delete(client_aktif.tutup) unless client_aktif.berlanjut?
	end

	def cek_permintaan(io, client)
		file = ""
		ukuran = nil
		diterima = io.recv(1000)

		case diterima
		when /GET \/(\w*) /
			folder = @folder_utama.clone
			folder += $1 + "/" unless $1.empty?
			return unless Dir.exist?(folder)
			file = file_utama(folder)
			if File.exist?(file)
				file = File.open(file, "rb")
				client.kirim_headerweb(file.size)
			elsif (s = Dir.entries(folder)).size == 3
				nama = s.pop
				tempat = folder + nama
				file = File.open(tempat, "rb")
				area = if diterima =~ /Range: bytes\=(\d*)-(\d*)/
					[$1, $2].collect { |i| i.empty? ? nil : i.to_i }
				else
					Array.new(2) { nil }
				end
				client.kirim_headerfile(nama, area, file.size)
				file.read(area[0]) if area[0]
				ukuran = area[1]
			end
		end

		return unless file.is_a?(IO)
		kirim_file(file, client, ukuran)
		file.close
	end

	def kirim_file(file, client, ukuran)
		ukuran ||= file.size
		jangka = 16384
		terkirim = 0

		loop do
			if terkirim + jangka > ukuran
				bagian = file.read(ukuran - terkirim)
				client.kirim(bagian)
				client.kirim("\r\n")
				break terkirim += bagian.size
			end

			bagian = file.read(jangka)
			client.kirim(bagian)
			client.kirim("\r\n")
			terkirim += jangka
		end

		client.kirim("0\r\n\r\n")
	end
end

module Tambahan
	class Client
		def initialize(server, client)
			@server = server
			@client = client
		end

		def waktu_header
			waktu = Time.now
			hari = ["Mng", "Sen", "Sel", "Rab", "Kam", "Jum", "Sab"][waktu.wday]
			tanggal = waktu.day
			bulan = ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Ags", "Sep", 
				"Okt", "Nov", "Des"][waktu.month]
			tahun = waktu.year
			jam = waktu.hour
			men = waktu.min
			detik = waktu.sec
			return sprintf("%s, %d %s %d %d:%d:%d GMT+7", hari, tanggal, bulan, tahun, jam, men, detik)
		end

		def kirim_headerweb(ukuran)
			header = [
				"HTTP/1.1 200 OK",
				"Date: #{waktu_header}",
				"Content-Length: #{ukuran}",
				"Content-Type: text/html; charset=utf-8",
				"Transfer-Encoding: chunked\r\n\r\n",
			]
			kirim header.join "\r\n"
		end

		def kirim_headerfile(nama, bagian, ukuran)
			header = [
				"HTTP/1.1 206 Partial Content",
				"Date: #{waktu_header}",
				"Content-Length: #{ukuran}",
				"Accept-Ranges: bytes",
				"Content-Range: bytes #{bagian[0] || 0}-#{bagian[1] || ukuran}/#{ukuran}",
				"Content-Type: application/octet-stream",
				"Content-Disposition: attachment; filename=\"#{nama}\"", 
				"Content-Transfer-Encoding: binary\r\n\r\n",
			]
			kirim header.join "\r\n"
		end

		def kirim(data)
			n = 0
			loop do
				n = io.syswrite(data)
				data = data.byteslice(n..-1)
				return if n == data.size
			end
		end

		def berlanjut?
			return false
		end

		def io
			return @client
		end

		def tutup
			@client.close
			return self
		end
	end
end

web = WebServer.new
web.folder_utama = "E:/Pekerjaan/Web/"
p web.mulai