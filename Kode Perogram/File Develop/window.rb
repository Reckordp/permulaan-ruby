$LOAD_PATH.push(__dir__)
require 'test_data.rb'
require 'mytest.so'
require 'win32api'
require 'cstruct/win32struct'

TextOut         = Win32API.new('gdi32', 'TextOut', 'LLLPL', 'I' )
cls = Buat_Window.new
# cls.data_window("HAI")

Cari = Win32API.new('user32', 'FindWindowA', 'PP', 'L')

cls.jalankan do
	handle = Cari.call("win32api", "Win32 App")
	"HAI WORLD"
	# pesan = "Win32API"
	# TextOut.call(handle_dc, 0, 0, pesan, pesan.size)
end