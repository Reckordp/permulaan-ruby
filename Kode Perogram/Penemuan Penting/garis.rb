def garis(titik_awal, titik_akhir)
	jarak_x = titik_awal.x - titik_akhir.x
	jarak_y = titik_awal.y - titik_akhir.y
	gerak_x = jarak_x.abs.next.to_f / jarak_y.abs.next.to_f
	gerak_y = jarak_y.abs.next.to_f / jarak_x.abs.next.to_f
	gerak_x *= -1 unless jarak_x.negative?
	gerak_y *= -1 unless jarak_y.negative?
	lewat_garis = []
	[jarak_x.abs, jarak_y.abs].max.next.times do |i|
		x = gerak_x.abs < 1 ? gerak_x * i : gerak_x.negative? ? -i : i
		y = gerak_y.abs < 1 ? gerak_y * i : gerak_y.negative? ? -i : i
		x += titik_awal.x
		y += titik_awal.y
		lewat_garis.push(Titik.new(x.to_i, y.to_i))
	end

	lewat_garis = lewat_garis.collect { |i| i.to_a }
	[titik_awal.y, titik_akhir.y].max.next.times do |y|
		[titik_awal.x, titik_akhir.x].max.next.times do |x|
			text = "(#{x}, #{y})"
			text = "G" if lewat_garis.include?([x, y])
			print text.center(8)
		end
		print "\n"
	end
end

class Titik
	attr_accessor :x, :y

	def initialize(x, y)
		@x = x
		@y = y
	end

	def to_a
		return [@x, @y]
	end

	def dup
		return self.class.new(@x, @y)
	end
	alias salin dup
	alias clone dup

	def ==(titik_lain)
		@x == titik_lain.x && @y == titik_lain.y
	end
end

titik_1 = Titik.new(rand(10), rand(10))
titik_2 = Titik.new(rand(10), rand(10))

garis(titik_1, titik_2)