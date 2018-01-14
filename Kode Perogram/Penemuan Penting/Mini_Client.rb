require 'socket'

client = TCPSocket.open("127.0.0.1", 80)
req = "GET / HTTP/1.1\r\nAccept: text/html, application/xhtml+xml, image/jxr, */*\r\nAccept-Language: id,ar-AE;q=0.7,ar;q=0.3\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Safari/537.36 Edge/13.10586\r\nAccept-Encoding: gzip, deflate\r\nHost: 127.0.0.1\r\nConnection: Keep-Alive\r\n\r\n"
# k2 = "GET / HTTP/1.1\r\nUser-Agent: Mozilla/5.0 (Windows NT 6.1; Trident/7.0; rv:11.0) like Gecko\r\nHost: 127.0.0.1\r\nAccept: */*\r\nAccept-Encoding: identity\r\nAccept-Language: id-ID\r\nAccept-Charset: *\r\nRange: bytes=0-\r\nReferer: http://127.0.0.1/\r\n\r\n"

client.puts(req)

n = true
t = false

begin
	p data = client.recv(1000)
rescue IO::WaitReadable
	IO.select([client])
	retry
end

client.close