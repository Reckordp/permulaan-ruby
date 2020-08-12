require 'benchmark'

class Contoh
	def initialize
		@umum = self.clone
	end
end

def factor(n)
	return 1 if n == 0
	factor(n - 1) * n
end

cls = nil

Benchmark.bm do |bench|
	bench.report("fct") do
		factor 999
	end
	bench.report("alc") do
		cls = Array.new(factor(10)) { Contoh.new }
	end
	bench.report("GC ") do
		cls = nil
		GC.start
	end
end