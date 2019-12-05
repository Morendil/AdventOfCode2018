lines = readlines.map(&:strip)
height = lines.length
width = lines.first.length

state = lines.flat_map {|line| line.split("")}

class Landscape
	def initialize(state, height, width)
		@state = state
		@height = height
		@width = width
		@future = state.dup
		@hashes = []
	end
	def at(x, y)
		return "." if (x < 0) || (x > @width-1) || (y < 0) || (y > @height-1)
		@state[x+y*@width]
	end
	def willbe(x, y, value)
		@future[x+y*@width] = value
	end
	def neighbours(x, y)
		[[-1,-1],[0,-1],[1,-1],[-1,0],[1,0],[-1,1],[0,1],[1,1]].map do |ox,oy|
			at(x+ox,y+oy)
		end
	end
	def evolve
		(0..@height-1).each do |y|
			(0..@width-1).each do |x|
				current = at(x, y)
				near = neighbours(x, y)
				trees = near.find_all {|c| c == "|"}.length
				lumber = near.find_all {|c| c == "#"}.length
				willbe(x,y,"|") if (current == ".") && trees >= 3
				willbe(x,y,"#") if (current == "|") && lumber >= 3
				if current == "#"
					willbe(x,y,".") unless (trees >= 1) && (lumber >= 1)
				end
			end
		end
		@state = @future
		@future = @state.dup
	end
	def show
		@state.each_slice(@width).map(&:join).join("\n")
	end
	def value
		trees = @state.find_all {|c| c == "|"}.length
		lumber = @state.find_all {|c| c == "#"}.length
		trees * lumber
	end
end

p height, width
land = Landscape.new(state,height,width)
500.times {land.evolve}
puts land.show
puts land.value
