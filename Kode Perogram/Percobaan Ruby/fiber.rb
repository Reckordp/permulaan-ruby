class Uji_Fiber
	def initialize
		@fiber = Fiber.new { Thread.current.thread_variable_set("foo", "bar") ; wilayah_fiber }
	end

	def update
		@fiber.resume if @fiber
	end

	def wilayah_fiber
		p Thread.current.thread_variable_get("foo")
		a = 1
		while a < 100
			a += 1
			Fiber.yield
		end
		@fiber = nil
	end

	def gk_kuat!
		@fiber.nil?
	end
end

cls = Uji_Fiber.new
cls.update until cls.gk_kuat!