module Data_Window
	@handle, @instance, @hdc = [0] * 3
	
	instance_variables.each do |variable|
		nama_method = "#{variable}"[1, "#{variable}".size - 1]
		define_singleton_method(nama_method.to_sym) { ambil_variable(variable) }
		define_singleton_method((nama_method + "=").to_sym) { |nilai| set_variable(variable, nilai) }
	end

	private
	def self.ambil_variable(variable)
		return instance_variable_get(variable)
	end

	def self.set_variable(variable, nilai)
		instance_variable_set(variable, nilai)
		return nil 
	end
end

