input = readlines
initial = input[0][15..-1].strip
rules = input[2..-1].map {|rule| [rule[0..4],rule[9]]}.to_h

generations = []

offset = 0
(0..800).each do |generation|
	leftmost = initial.index("#")
	rightmost = -(initial.reverse.index("#")+1)
	trimmed = initial[leftmost..rightmost]
	generations << [trimmed, offset]

	evolved = ""
	field = ("."*3)+trimmed+("."*3)
	(0..field.length-5).each do |i|
		evolved << (rules[field[i..i+4]] || ".")
	end
	initial = evolved

	leftmost = initial.index("#")
	offset += 1-leftmost
end

max_offset = generations.collect(&:last).max
lengths = generations.collect(&:first).collect(&:length)
lengths_with_offsets = lengths.zip(generations.collect(&:last)).map {|a,b| a-b}
max_length = lengths_with_offsets.max

# generations.each_with_index do |generation, index|
# 	header = index.to_s.ljust(2," ")+": "
# 	display = "".rjust(1+max_offset-generation[1],".")+generation[0].ljust(max_length+generation[1]+1,".")
# 	puts header+display
# end

sum = 0
reached = generations.last.first
reached.split("").each_with_index do |c,i|
	sum += i-generations.last.last if c == "#"
end
p sum
