data = [[255, 255, 255], [50, 24, 40]]

color = data.collect{ |i| i.pack('L*') }
matang = [color[0]].pack('m') + "ganti1234" + [color[1]].pack('m')

File.binwrite('k', matang)

muat = File.binread('k')

muat = muat.split("ganti1234").collect { |i| i.unpack('m')[0] }
muat = muat.collect { |i| i.unpack('L*') }
p muat