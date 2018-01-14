require 'win32api'
require 'cstruct/win32struct'

class Status_Batre < Win32Struct
	BYTE	:ACLineStatus
	BYTE	:BatteryFlag
	BYTE	:BatteryLifePercent
	BYTE	:SystemStatusFlag
	DWORD	:BatteryLifeTime
	DWORD	:BatteryFullLifeTime
end

Dapat_Status = Win32API.new('kernel32', 'GetSystemPowerStatus', 'P', 'I')
status = Status_Batre.new

Dapat_Status.call(status.data)

print "Sedang Mengisi - " if status.ACLineStatus == 1
system "pause"