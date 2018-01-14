class Pohon
	attr_reader :nama, :buah
	def initialize(&block)
		argumen = block.method(:call)
		@nama = argumen[0]
		@buah = argumen[1]
	end

	def nama=(nama)
		@nama = nama
	end

	def inspect
		"Pohon #{@nama} akan berbuah #{@buah}"
	end
end


tumbuhan = Pohon.new do
	nama = "Debog"
	buah = "Pisang"
end

p tumbuhan