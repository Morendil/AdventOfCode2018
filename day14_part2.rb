scoreboard = [3, 7]
elves = [0, 1]

recipes = 409551.to_s.split("").map(&:to_i)
tailend = []
length = recipes.length
found = 0

begin
	currents = elves.map {|current| scoreboard[current]}
	generated = currents.sum.to_s.split("").map(&:to_i)
	# Much faster than "+"
	generated.each_with_index do |digit, index|
		tailend << digit
		tailend = tailend[-length..-1] if tailend.length > length
		found = (scoreboard.length - length + index + 1) if (found == 0) && (tailend == recipes)
	end
	scoreboard.concat(generated)
	elves = elves.map do |current|
		(current + scoreboard[current] + 1) % scoreboard.length
	end
end until found > 0

p found
