require_relative 'heap'

K = 20183

depth = 510
target = [10,10]
map = {}

def neighbours(map, xy)
	x,y = xy
	[[-1,0],[1,0],[0,1],[0,-1]].map do |ox,oy|
		[x+ox,y+oy]
	end.select {|x,y| (x >= 0) && (y >= 0)}.select {|xy| map[xy]}
end

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

def assess(map, target, beyond, depth)
	origin = [0, 0]
	begin
		(origin[0]..target[0]+beyond[0]).each do |x|
			xy = [x, origin[1]]
			map[xy] = level(map, xy, target, depth)
		end
		(origin[1]+1..target[1]+beyond[1]).each do |y|
			xy = [origin[0], y]
			map[xy] = level(map, xy, target, depth)
		end
		origin = [[origin[0]+1,target[0]+beyond[0]].min,[origin[1]+1,target[1]+beyond[1]].min]
	end while origin != [target[0]+beyond[0],target[1]+beyond[1]]
end

def dist(xy1, xy2)
	(xy1[0]-xy2[0]).abs + (xy1[1]-xy2[1]).abs
end

def visualize(target, beyond, openl, closedl, map)
	origin = [0, 0]
	puts "\e[2J\e[H" +
	  "#{$iter} best=#{openl.list[1][2]+openl.list[1][3]} open=#{openl.list.length-1} closed=#{closedl.length}\n" +
	  ((origin[1]..(target[1]+beyond[1])).map do |y|
	  	(["t","g","n"].map do |equip|
			((origin[0]..(target[0]+beyond[0])).map do |x|
				xy = [x, y]
				if openl.list.any? {|m| m[0..1] == [xy, equip] }
					equip
				elsif closedl.any? {|m| m[0..1] == [xy, equip] }
					equip.upcase
				elsif xy == target[0..1]
					"X"
				else
					map[xy]
				end
			end).join('')
		end).join("    ")
	end).join("\n")
	STDOUT.flush
	# p openl.list.collect {|x| x[0..3]}
	# p closedl.collect {|x| x[0..3]}
	sleep 0.00000001
end

def visualize_moves(target, beyond, moves, map)
	origin = [0, 0]
	puts "\e[2J\e[H" +
	  "#{$iter}\n" +
	  ((origin[1]..(target[1]+beyond[1])).map do |y|
	  	(["t","g","n"].map do |equip|
			((origin[0]..(target[0]+beyond[0])).map do |x|
				xy = [x, y]
				if moves.any? { |m| m[0..1] == [xy, equip] }
					equip
				elsif xy == target[0..1]
					"X"
				else
					map[xy]
				end
			end).join('')
		end).join("    ")
	end).join("\n")
	STDOUT.flush
	readline
end

squares = {0=>".", 1=>"=", 2=>"|"}
BEYOND = [30,60]
assess(map, target, BEYOND, depth)
map = map.map {|k,v| [k,squares[v%3].to_sym]}.to_h
allowed = {
	".":"tg",
	"=":"ng",
	"|":"nt"
}

origin = [0,0]

def compare(a, b)
	(a[2]+a[3]) < (b[2]+b[3])
end

openl = Heap.new(lambda {|a,b| compare(a,b)}, [nil,nil,-1.0/0,-1.0/0])
openl.push([origin,"t",0,dist(origin, target)])
closedl = []
max_x = 0
max_y = 0
$iter = 0
while (!openl.empty?)
	current = openl.pop
	from, equip, cost, dist = current
	leaving = map[from]
	investigate = neighbours(map, from)
	investigate = investigate.select {|xy| allowed[map[xy]].include?(equip)}
	switch = (allowed[leaving].split("")-[equip]).first
	moves = (investigate.map {|xy| [xy, equip, cost+1, dist(xy, target), current]})
		.concat([[from, switch, cost+7, dist, current]])
	# visualize_moves(target, BEYOND, moves, map)
	moves.each do |move|
		enqueue = [openl, closedl].none? { |l|
			l.any? {|existing| (existing[0] == move[0]) && (existing[2]+existing[3] <= move[2]+move[3])} }
		openl.push(move) if enqueue
	end
	closedl << current
	break if current[0..1] == [target,"t"]
	# visualize(target, BEYOND, openl, closedl, map)
	$iter += 1
end

finish = closedl.find {|x| x[0..1] == [target,"t"]}
p $iter
p finish[2]
route = [finish[0..2]]
begin
	finish = finish[4]
	route << finish[0..2]
end until finish[0] == origin
route.reverse.each {|x| p x}
