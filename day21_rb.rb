a = 0
b = 0
e = 0
min_e = 999999999
seen = []
begin
	d = e | 65536
	e = 707129
	begin
		c = d & 255
		e = c + e
		e = e & 16777215
		e = e * 65899
		e = e & 16777215
		break if 256 > d
		c = 0
		begin
			b = c + 1
			b = b * 256
			if b > d
				d = c
				break
			end
			c = c + 1
		end while true
	end while true
	if seen.include? e
		p "Already seen #{e}"
		p seen.length
		p seen.last
		break
	end
	seen << e
end while a != e
