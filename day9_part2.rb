players = 459
highest = 7179000
current = [0, nil, nil]
current[1] = current
current[2] = current
value = 1
scores = {}

def next(marble)
	marble[1]
end

def insert(marble, value)
	new_marble = [value, marble, marble[2]]
	marble[2][1] = new_marble
	marble[2] = new_marble
	new_marble
end

def delete(marble)
	prv = marble[1]
	nxt = marble[2]
	prv[2] = nxt
	nxt[1] = prv
	nxt
end

(1..players).cycle do |player|
	if value % 23 == 0
		scores[player] = (scores[player] || 0) + value
		(1..7).each do
			current = current[1]
		end
		scores[player] += current[0]
		current = delete(current)
	else
		current = insert(current[2], value)
	end
	break if value > highest
	value += 1
end

p scores.values.max
