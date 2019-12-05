K = 20183

depth = 510
target = [10,10]

class Landscape
	def initialize()
		@state = {}
	end
	def assess(target, expand, depth)
		origin = [0, 0]
		begin
			(origin[0]..target[0]+expand[0]).each do |x|
				xy = [x, origin[1]]
				set(xy, level(xy, target, depth))
			end
			(origin[1]+1..target[1]+expand[1]).each do |y|
				xy = [origin[0], y]
				set(xy, level(xy, target, depth))
			end
			origin = [[origin[0]+1,target[0]+expand[0]].min,[origin[1]+1,target[1]+expand[1]].min]
		end while origin != [target[0]+expand[0],target[1]+expand[1]]
	end
	def level(xy, target, depth)
		x, y = xy
		if (xy == [0,0]) || (xy == target)
			(0 + depth) % K
		elsif x == 0
			((48271 * y) + depth) % K
		elsif y == 0
			((16807 * x) + depth) % K
		else
			((at([x-1,y]) * at([x,y-1])) + depth) % K
		end
	end
	def convert
		squares = {0=>".", 1=>"=", 2=>"|"}
		@state = @state.map {|k,v| [k,squares[v%3]]}.to_h
	end
	def at(xy)
		x, y = xy
		@state[[x,y]]
	end
	def set(xy, value)
		x, y = xy
		@state[[x,y]] = value
	end
end

def neighbours(map, xy)
	x,y = xy
	[[-1,0],[1,0],[0,1],[0,-1]].map do |ox,oy|
		[x+ox,y+oy]
	end.select {|x,y| (x >= 0) && (y >= 0)}.select {|xy| map.at(xy)}
end

def dist(xy1, xy2)
	(xy1[0]-xy2[0]).abs + (xy1[1]-xy2[1]).abs
end

map = Landscape.new()
map.assess(target, [2,2], depth)
map.convert

allowed = {
	".":"tg",
	"=":"ng",
	"|":"nt"
}

origin = [0,0]
openl = [[origin,"t",0,dist(origin, target)]]
closedl = []
max_x = 0
max_y = 0
while (!openl.empty?) && !closedl.map{|x| x[0..1]}.include?([target,"t"]) do
	current = openl.shift
	from, equip, cost, dist = current
	leaving = map.at(from)
	investigate = neighbours(map, from)
	investigate = investigate.select {|xy| allowed[map.at(xy).to_sym].include?(equip)}
	switch = (allowed[leaving.to_sym].split("")-[equip]).first
	moves = (investigate.map {|xy| [xy, equip, cost+1, dist(xy, target), current]})
		.concat([[from, switch, cost+7, dist, current]])
	moves.each do |move|
		existing = (openl+closedl).select {|node| (node[0] == move[0]) && (node[1] == move[1])}
		enqueue = existing.empty? || (existing.first[2] > move[2])
		if enqueue
			max = move[2]+move[3]
			ix = openl.find_index {|x| (x[2]+x[3]) >= max} || 0
			openl.insert(ix, move)
		end
	end
	# openl = openl.sort {|a,b| (a[2]+a[3]) <=> (b[2]+b[3])}
	closedl << current
end

finish = closedl.find {|x| x[0..1] == [target,"t"]}
p finish[2]
route = [finish[0..2]]
begin
	finish = finish[4]
	route << finish[0..2]
end until finish[0] == origin
route.reverse.each {|x| p x}
