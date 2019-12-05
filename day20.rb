regex = readline[1..-2]

offsets = {E: [1,0], N: [0,-1], S: [0, 1], W: [-1, 0]}

location = [0,0]
pointer = 0
stack = []
track = []
distances = {[0,0] => 0}

begin
	char = regex[pointer]
	case char
	when "E","N","S","W"
		new_location = location.zip(offsets[char.to_sym]).map {|a,b| a+b}
		if new_location == track[-2]
			track.pop
			location = new_location
		else
			if distances[new_location] && (distances[new_location]-distances[location]).abs > 1
				puts "Already seen #{new_location}, #{char} of #{location} - #{pointer}"
				puts "Shortcut #{distances[new_location]} #{distances[location]}"
				break
			end
			distances[new_location] = distances[location] + 1
			location = new_location
			track.push(location)
		end
	when "("
		stack.push(location)
	when "|"
		location = stack.last
	when ")"
		location = stack.pop
	end
	pointer += 1
end while pointer < regex.length
p distances.values.max
p distances.values.select {|v| v >= 1000}.length
