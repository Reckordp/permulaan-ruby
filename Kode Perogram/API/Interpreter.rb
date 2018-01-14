require 'Win32API'

CreateWindowEx = Win32API.new("user32","CreateWindowEx",'lpplllllllll','l')
ShowWindow = Win32API.new('user32','ShowWindow','ll','l')
SetWindowText = Win32API.new('user32','SetWindowText','pp','i')

args = [0x00000100, "static", "YES", 0x80000000, 0, 0, 100, 96, 0, 0,0,0]

@window = CreateWindowEx.(*args)

args2 = [0, "static", "[HAI] [WAU] [INI] [SOGE]", 0x40000000,10,150,260,40, @window, 0,0,0]

@text = CreateWindowEx.(*args2)

loop do 
	ShowWindow.(@window, 1)
end