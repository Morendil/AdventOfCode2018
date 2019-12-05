K = 20183

depth = 5616
target = [10,785]
map = {}

def level(map, xy, target, depth)
	x, y = xy
	if (xy == [0,0]) || (xy == target)
		(0 + depth) % K
	elsif x == 0
		((48271 * y) + depth) % K
	elsif y == 0
		((16807 * x) + depth) % K
	else
		((map[[x-1,y]] * map[[x,y-1]]) + depth) % K
	end
end

origin = [0, 0]
begin
	(origin[0]..target[0]).each do |x|
		xy = [x, origin[1]]
		map[xy] = level(map, xy, target, depth)
	end
	(origin[1]+1..target[1]).each do |y|
		xy = [origin[0], y]
		map[xy] = level(map, xy, target, depth)
	end
	origin = [[origin[0]+1,target[0]].min,[origin[1]+1,target[1]].min]
end while origin != target

p map.values.map {|v| v % 3}.sum
