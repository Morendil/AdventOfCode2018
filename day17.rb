def parse_range(range)
	/(?<coord>[xy])=(?<start>[\d]+)(..(?<stop>[\d]+))?/ =~ range
	start = start.to_i
	stop = (stop || start).to_i
	[coord, start..stop]
end

def parse_vein(vein)
	vein.split(",")
		.map(&:strip)
		.map {|range| parse_range(range)}
		.sort {|a,b| a[0] <=> b[0]}
		.collect {|range| range[1]}
end

class Map
	def initialize(veins)
		@veins = veins
	end
	def expand
		by_y = @veins.sort {|v1,v2| v1[1].first <=> v2[1].first}
		by_x = @veins.sort {|v1,v2| v1[0].first <=> v2[0].first}
		xmin = by_x.first[0].first-1
		xmax = by_x.last[0].last+1
		ymin = by_y.first[1].first
		ymax = by_y.last[1].last
		@yrange = ymin..ymax
		@xrange = xmin..xmax
		@map = @yrange.map {|x| "." * @xrange.size}
		@veins.each do |xx, yy|
			yy.each do |y|
				xx.each do |x|
					@map[y-@yrange.first][x-@xrange.first] = "#"
				end
			end
		end
	end
	def show
		@map.join("\n")
	end
	def at(xy)
		x, y = xy
		@map[y-@yrange.first][x-@xrange.first]
	end
	def set(xy, value)
		x, y = xy
		@map[y-@yrange.first][x-@xrange.first] = value
	end
	def ymax
		@yrange.last
	end
	def ymin
		@yrange.first
	end
	def xmax
		@xrange.last
	end
	def xmin
		@xrange.first
	end
	def left_of(xy)
		x, y = xy
		(x-1).downto(@xrange.first-1)
	end
	def right_of(xy)
		x, y = xy
		(x+1).upto(@xrange.last+1)
	end
end

veins = readlines.map {|vein| parse_vein(vein)}
map = Map.new(veins)
map.expand

sources = [[500, map.ymin]]

begin
	source = sources.shift
	origin = source.dup

	# Fall
	fill = false
	scooped = false
	current = []
	source[1].upto(map.ymax) do |y|
		current = [source[0],y]
		under = [source[0],y+1]
		into = under[1] > map.ymax ? "." : map.at(under)
		case into
		when "|"
			map.set(current,"|")
			scooped = true
			break
		when "."
			map.set(current,"|") unless map.at(current) == "+"
		when "#", "~"
			fill = true
			break
		end
	end
	source = current

	next if scooped
	next if !fill
	begin
		left = false
		left_x = source[0]
		map.left_of(source).each do |x|
			case map.at([x, source[1]])
			when ".","|"
				if [".","|","+"].include?(map.at([x, source[1]+1]))
					left_x = x
					break
				end
			when "#"
				left_x = x+1
				left = true
				break
			end
		end
		right = true
		right_x = source[0]
		map.right_of(source).each do |x|
			case map.at([x, source[1]])
			when ".","|"
				right = false
				if [".","|","+"].include?(map.at([x, source[1]+1]))
					right_x = x
					break
				end
			when "#"
				right_x = x-1
				right = true
				break
			end
		end
		(left_x..right_x).each do |x|
			flooded = [x,source[1]]
			map.set(flooded, (left && right) ? "~" : "|")
			# puts "deleted #{flooded}" if sources.include? flooded
			sources.delete(flooded)
		end
		source = [source[0], source[1]-1] if (left && right)
	end until !(left && right)
	if (!right)
		sources << [right_x, source[1]+1]
		# puts "created #{[right_x, source[1]+1]} (r) from #{source}"
		# map.set([right_x, source[1]+1],"+")
	end
	if (!left)
		sources << [left_x, source[1]+1]
		# puts "created #{[left_x, source[1]+1]} (l) from #{source}"
		# map.set([left_x, source[1]+1],"+")
	end
	sources = sources.uniq
end until sources.empty?

puts map.show
puts map.show.split("").find_all {|c| ["~","|"].include?(c)}.length
puts map.show.split("").find_all {|c| c == "~"}.length
