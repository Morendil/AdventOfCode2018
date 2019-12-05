input = readlines
initial = input[0][15..-1].strip
rules = input[2..-1].map {|rule| [rule[0..4],rule[9]]}.to_h

last_gen = []
last_offset = 0

cache = {}

offset = 0
(0..100).each do |generation|
	leftmost = initial.index("#")
	rightmost = -(initial.reverse.index("#")+1)
	trimmed = initial[leftmost..rightmost]
	last_gen = trimmed
	last_offset = offset

	evolved = ""
	cached = cache[trimmed]
	if cached
		evolved = cached
	else
		field = ("."*3)+trimmed+("."*3)
		(0..field.length-5).each do |i|
			evolved << (rules[field[i..i+4]] || ".")
		end
		cache[trimmed] = evolved
	end
	initial = evolved

	leftmost = initial.index("#")
	offset += 1-leftmost
end

total = 50000000000
# total = 800
last_offset -= (total-100)
sum = 0
reached = last_gen
reached.split("").each_with_index do |c,i|
	sum += i-last_offset if c == "#"
end
p sum
