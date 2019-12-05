require 'set'

def close(word, target)
	result = -1
	(0..word.length-1).each do |index|
		next if word[index] == target[index]
		return -1 if result >= 0
		result = index
	end
	return result
end

words = readlines.map(&:strip)
boxes = words.select {|word| words.detect {|target| close(word, target) >= 0}}

puts boxes
common = boxes[0].split("")
common.delete_at(close(boxes[0], boxes[1]))
common = common.join("")
puts common
