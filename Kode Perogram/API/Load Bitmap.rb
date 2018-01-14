require 'win32api'
Load = Win32API.new('user32', 'LoadImage', 'IPIIII', 'I')

nama_bitmap = 'File Develop/warna.bmp'
p Load.call(0, nama_bitmap, 0, 0, 0x00000040, 0x00000010)