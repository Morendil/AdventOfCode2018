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

size = 0
(xmin..xmax).each do |x|
	(ymin..ymax).each do |y|
		distances = coordinates.map {|xy| dist(xy,[x,y])}
		size += 1 if distances.sum < 10000
	end
end
puts size
