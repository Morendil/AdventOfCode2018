serial = 7347

grid = {}

(1..300).each do |x|
	(1..300).each do |y|
		rack = x + 10
		powr = rack * y
		powr += serial
		powr *= rack
		powr = ((powr % 1000) / 100) - 5
		grid["#{x},#{y}"] = powr
	end
end

max = -999999
maxc = nil
(1..300).each do |size|
	offsets = (0..size-1).flat_map { |x| (0..size-1).map {|y| [x, y]}}
	(1..(300-size+1)).each do |x|
		(1..(300-size+1)).each do |y|
			block = offsets
				.map {|p| ox,oy=p; grid["#{x+ox},#{y+oy}"] || 0}
				.sum
			if block > max
				max = block
				maxc = "#{x},#{y},#{size}"
			end
		end
	end
	p maxc, max
end

p maxc
