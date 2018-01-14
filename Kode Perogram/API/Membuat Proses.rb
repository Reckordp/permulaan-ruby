require 'win32api'
require 'cstruct/win32struct'

Proses  = Win32API.new('kernel32','CreateProcess', 'IPIIIIIIPP', 'I')
CFile   = Win32API.new('kernel32', 'CreateFile', 'PIIIIII', 'I')
Copy    = Win32API.new('kernel32', 'CopyFile', 'PPI', 'I')
Pindah  = Win32API.new('kernel32', 'MoveFile', 'PP', 'I')

bahan = 'hello.exe'

class STARTUPINFO < Win32Struct
  DWORD       :cb
  LPCSTR      :lpReserved
  LPCSTR      :lpDekstop
  LPCSTR      :lpTitle
  DWORD       :dwX
  DWORD       :dwY
  DWORD       :dwXSize
  DWORD       :dwYSize
  DWORD       :dwXCountChars
  DWORD       :dwYCountChars
  DWORD       :dwFileAttribute
  DWORD       :dwFlags
  WORD        :wShowWindow
  WORD        :cbReserved2
  LPBYTE      :lpReserved2
  HANDLE      :HStdInput
  HANDLE      :HStdOutput
  HANDLE      :HStdError
end

class PROCESS_INFORMATION < Win32Struct
  HANDLE      :hProcess
  HANDLE      :hThread
  DWORD       :dwProcessId
  DWORD       :dwThreadId
end

pi = PROCESS_INFORMATION.new
si = STARTUPINFO.new

Proses.call(0, bahan, 0, 0, 1, 0, 0, 0, si.data, pi.data)