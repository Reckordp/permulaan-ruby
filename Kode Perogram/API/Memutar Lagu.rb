require 'win32api'

play = Win32API.new('winmm', 'PlaySound', 'PLL', 'I')
tempat_wav = "C:\\FFOutput\\Absorb1.wav"

play.call(tempat_wav, 0, 0x0002)