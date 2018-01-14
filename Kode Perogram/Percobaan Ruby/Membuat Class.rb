puts "Apa Nama Class Yang Akan Kita Buat?"
clazz = gets.strip.capitalize
Object.const_set(clazz, Class.new)
clazz = Object.const_get(clazz)