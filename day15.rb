cavern = readlines.map {|line| line.strip.split("")}

fighters = []
powers = {"G":3, "E":10} # part 2
cavern.each_with_index do |line, y|
	line.each_with_index do |square, x|
		fighters << [x, y, square, powers[square.to_sym], 200] if ['G','E'].include?(square)
	end
end

def neighbours(xy)
	x, y = xy
	offsets = [[0,-1],[-1,0],[1,0],[0,1]]
	offsets.map {|dxy| [xy[0]+dxy[0],xy[1]+dxy[1]]}
end

def blocked(cavern, x, y, ignore)
	outside = y < 0 || x < 0 || y >= cavern.length || x >= cavern[0].length
	square = cavern[y][x]
	occupied = square != '.' && square != ignore
	occupied || outside
end

def free_neighbours(cavern, pt, ignore="")
	neighbours(pt).reject {|xy| blocked(cavern, xy[0], xy[1], ignore)}
end

def show_region(cavern, region)
	cavern = cavern.map(&:dup)
	region.keys.each do |xy|
		cavern[xy[1]][xy[0]] = region[xy] % 10
	end
	cavern.map(&:join).join("\n")
end

def fill_region(cavern, point)
	distance = 0
	result = {}
	explored = [point[0..1]]
	marker = 0
	begin
		next_steps = []
		explored[marker..-1].each do |point|
			around = free_neighbours(cavern, point)
				.reject {|xy| next_steps.include?(xy)}
				.reject {|xy| explored.include?(xy)}
			next_steps.concat(around)
			result[point] = distance if distance > 0
		end
		marker = explored.length
		explored.concat(next_steps)
		distance += 1
	end until next_steps.empty?
	result
end

def do_turn(cavern, fighters, unit)
	enemy = {"G":"E","E":"G"}
	enemies = fighters.select {|fighter| fighter[2] == enemy[unit[2].to_sym]}
	return false if unit[2] == "X"
	return true if enemies.empty?
	# In range
	spots = enemies.flat_map {|enemy| free_neighbours(cavern, enemy, unit[2])}.uniq
	# If not already in range
	if !spots.include?(unit[0..1])
		region = fill_region(cavern, unit)
		# Reachable
		spots = spots.select {|spot| region[spot]}
		if !spots.empty?
			# Nearest
			min_dist = spots.map {|spot| region[spot]}.min
			spots = spots.select {|spot| region[spot] == min_dist}
			dspots = spots.dup
			# Walk back
			steps = spots.map do |spot|
				step = spot
				while region[step] > 1 do
					neighbours = free_neighbours(cavern, step)
					min = neighbours.collect {|xy| region[xy]}.min
					step = neighbours.select {|xy| region[xy] == min}.first
				end
				step
			end
			# Reading order, then pick first
			# steps = steps.sort {|a,b| a[1] == b[1] ? a[0] <=> b[0] : a[1] <=> b[1]}
			step = steps.first
			# Move unit
			x, y = unit[0..1]
			cavern[y][x] = "."
			unit[0], unit[1] = step
			x, y = unit[0..1]
			cavern[y][x] = unit[2]
		end
	end
	# Attack
	targets = neighbours(unit[0..1])
		.flat_map {|spot| enemies.select {|fighter| fighter[0..1] == spot}}
		.sort {|f1, f2| f1[4] <=> f2[4]}
	if !targets.empty?
		target = targets.first
		target[4] -= unit[3]
		if target[4] <= 0
			puts "Lost an Elf" if target[2] == "E" # part 2
			return true if target[2] == "E" # part 2
			x, y = target[0..1]
			cavern[y][x] = "."
			target[2] = "X"
		end
	end
	return false
end

debug = {}
ended = false
turn = 0
# puts show_region(cavern, debug)
# p fighters
begin
	fighters = fighters.sort {|a,b| a[1] == b[1] ? a[0] <=> b[0] : a[1] <=> b[1]}
	fighters.each do |unit|
		ended = ended || do_turn(cavern, fighters, unit)
	end
	turn += 1 unless ended
	# puts show_region(cavern, debug)
	# p turn #, fighters
	fighters = fighters.reject {|fighter| fighter[2] == "X"}
end while !ended
total = fighters.map{|fighter| fighter[4]}.sum
puts "#{turn} * #{total} = #{turn * total}"

# unit movement:
# ✓ list enemy unit attack spots
# ✓ check if not already in range
# ✓ floodfill region with distances
# ✓ narrow to attack spots in region
# ✓ narrow to nearest
# ✓ walk back to starting steps
# ✓ order starting steps
# ✓ move unit
# ✓ deal damage
# ✓ check for death
# ✓ check for end of fight
# ✓ compute outcome
