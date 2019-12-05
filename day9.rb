players = 459
highest = 71790
marbles = [0]
current = 0
value = 1
scores = {}

(1..players).cycle do |player|
	if value % 23 == 0
		scores[player] = (scores[player] || 0) + value
		place = (current - 7) % marbles.length
		scores[player] += marbles[place]
		marbles.delete_at(place)
		current = place
	else
		place = current == marbles.length-1 ? 1 : current + 2
		marbles.insert(place, value)
		current = place
	end
	break if value > highest
	value += 1
end

p scores.values.max
