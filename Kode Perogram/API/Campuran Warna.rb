class RGB
	attr_accessor :r, :g, :b

	def initialize(r = 255, g = 255, b = 255)
		@r = r
		@g = g
		@b = b
	end

	def campur(lain, alpha)
		alpha /= 255.0
		opacity = 1 - alpha

		r = lain.r * alpha + opacity * @r
		g = lain.g * alpha + opacity * @g
		b = lain.b * alpha + opacity * @b

		return self.class.new(r, g, b)
	end

	def inspect
		return "r: #{@r}	g: #{@g}	b: #{@b}"
	end
end

latar = RGB.new(0, 255, 0)
obyek = RGB.new(255, 0, 0)

p latar.campur(obyek, 204)