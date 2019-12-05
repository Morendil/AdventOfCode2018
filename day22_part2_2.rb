require_relative 'heap'

K = 20183

depth = 510
target = [10,10]

class Landscape
	def initialize(target, depth)
		@squares = squares = {0=>".".to_sym, 1=>"=".to_sym, 2=>"|".to_sym}
		@state = (0..(target[1]*2)).map {(0..(target[0]*2)).map {nil}}
		@target = target
		@depth = depth
		@max_x = 0
		@max_y = 0
	end
	def at(xy)
		data(xy)[1]
	end
	def data(xy)
		x, y = xy
		cached = @state[y][x]
		return cached unless cached.nil?
		erosion = if (xy == [0,0]) || (xy == @target)
			0
		elsif x == 0
			(48271 * y)
		elsif y == 0
			(16807 * x)
		else
			data([x-1,y])[0] * data([x,y-1])[0]
		end
		level = (erosion + @depth) % K
		@state[y][x] = [level, @squares[level%3]]
	end
  def visualize(openl, closedl)
    target = @target
    puts "\e[2J\e[H" +
      "#{$iter} best=#{openl.list[1][2]+openl.list[1][3]} open=#{openl.list.length-1} closed=#{closedl.length}\n" +
      ((0..target[1]).map do |y|
        (["t","g","n"].map do |equip|
        ((0..target[0]).map do |x|
          xy = [x, y]
          if openl.list.any? {|m| m[0..1] == [xy, equip] }
            equip
          elsif closedl.any? {|m| m[0..1] == [xy, equip] }
            equip.upcase
          elsif xy == target[0..1]
            "X"
          else
            at(xy)
          end
        end).join('')
      end).join("    ")
    end).join("\n")
    STDOUT.flush
    # p openl.list.collect {|x| x[0..3]}
    # p closedl.collect {|x| x[0..3]}
    sleep 0.00000001
  end
end

def neighbours(map, xy)
	x,y = xy
	[[-1,0],[1,0],[0,1],[0,-1]].map do |ox,oy|
		[x+ox,y+oy]
	end.select {|x,y| (x >= 0) && (y >= 0)}
end

def dist(xy1, xy2)
	(xy2[0]-xy1[0]).abs + (xy2[1]-xy1[1]).abs
end

map = Landscape.new(target, depth)

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
$iter = 0
while (!openl.empty?)
	current = openl.pop
	from, equip, cost, dist = current
	leaving = map.at(from)
	investigate = neighbours(map, from)
	investigate = investigate.select {|xy| allowed[map.at(xy)].include?(equip)}
	switch = (allowed[leaving].split("")-[equip]).first
	moves = (investigate.map {|xy| [xy, equip, cost+1, dist(xy, target), current]})
		.concat([[from, switch, cost+7, dist, current]])
	# visualize_moves(target, moves, map)
	moves.each do |move|
		enqueue = [openl, closedl].none? { |l|
			l.any? {|existing| (existing[0..1] == move[0..1]) && (existing[2]+existing[3] <= move[2]+move[3])} }
		# should also remove the worse ones from open queue
		openl.push(move) if enqueue
	end
	closedl << current
	break if current[0..1] == [target,"t"]
	map.visualize(openl, closedl)
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
# route.reverse.each {|x| p x}
