coordinates = readlines.map {|pair| pair.split(",").map(&:strip).map(&:to_i)}

# Manhattan distance
def dist(a,b)
	(a[0]-b[0]).abs+(a[1]-b[1]).abs
end
# Get the min and max xy of all coords
xs = coordinates.collect {|xy| xy[0]}
ys = coordinates.collect {|xy| xy[1]}
xmin, xmax = [xs.min, xs.max]
ymin, ymax = [ys.min, ys.max]
# Old plan…
# def expand(xy)
# 	[[0,1],[0,-1],[1,0],[-1,0]].map {|dxy| [xy[0]+dxy[0],xy[1]+dxy[1]]}
# end
# # Filter the coords whose x and y are strictly between the min and max
# starters = coordinates.select {|xy| x, y = xy; x>xmin and x<xmax and y>ymin and y<ymax}
# # Each of these is a starter for an area
# areas = starters.map {|xy| [xy]}
# # Expand each area, adding points not closer than n to any other
# def grow(coords, area, n)
# 	coords = coords.dup.delete(area[0])
# 	fringe = area.flat_map {|xy| expand(xy)}.uniq
# 	area.each {|pt| fringe.delete(pt)}
# 	fringe.select {|pt| coords.none? {|coord| dist(pt, coord) <= n}}
# end

cells = {}
(xmin..xmax).each do |x|
	(ymin..ymax).each do |y|
		distances = coordinates.map {|xy| dist(xy,[x,y])}
		md = distances.min
		tied = distances.find_all {|x| x == md}.length > 1
		next if tied
		zone = distances.find_index(md)
		cells[zone] = (cells[zone] || 0) + 1
	end
end
puts cells.values.max
