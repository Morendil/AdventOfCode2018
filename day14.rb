scoreboard = [3, 7]
elves = [0, 1]

recipes = 409551

begin
	currents = elves.map {|current| scoreboard[current]}
	generated = currents.sum.to_s.split("").map(&:to_i)
	# Much faster than "+"
	scoreboard.concat(generated)
	elves = elves.map do |current|
		(current + scoreboard[current] + 1) % scoreboard.length
	end
end until scoreboard.length >= recipes + 10

p scoreboard[recipes..recipes+9].join
