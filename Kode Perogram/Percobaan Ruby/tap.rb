class Contoh
	def initialize(&blk)
		puts "hai"
		trap(:INT) { puts "Haa" }

		yield("Hahah")

		begin
			HAHAHA.new
		ensure
			puts "Keluar"
		end
	end
end


begin
	Contoh.new.tap do |kls|
		p kls
	end
rescue Exception => e
	p e
end

system "pause"