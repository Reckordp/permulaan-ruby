require 'Win32API'

def ambil_lpcstr(init_string, max_length = 256)
	la = Win32API.new('kernel32', 'LocalAlloc', 'LL', 'L')
	mm = Win32API.new('msvcrt', 'memset', 'LLL', 'L')
	buffer_pointer = la.call(0, max_length)
	buffer_addr = buffer_pointer
	mm.call(buffer_addr, 0, max_length)
	init_string.each_byte do |byte|
		mm.call(buffer_pointer, byte, 1)
		buffer_pointer += 1
	end
	buffer_addr
end

Buka = Win32API.new('Shell32', 'ShellExecute', 'ILLLLI')

Buka.call(0, ambil_lpcstr('open'), ambil_lpcstr('C:/Users/Reckordp/Videos/One Pice'), 0, 0, 10)