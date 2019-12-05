polymer = readlines[0].strip
def react(polymer)
	units = polymer.split("")
	inert = false
	until inert
		deletions = []
		units.each_with_index do |val,i|
			next if i==0
			matched = (units[i-1].upcase == units[i].upcase)
			opposed = matched && (units[i-1] != units[i])
			overlap = deletions[-1] && (i-deletions[-1] <= 2)
			deletions += [i-1,i] if opposed && !overlap
		end
		inert = deletions.empty?
		deletions.reverse.each do |pos|
			units.delete_at pos
		end
	end
	units.length
end
# puts react(polymer)

unit_types = polymer.split("").map(&:upcase).uniq
lengths = unit_types.map {|letter| react(polymer.gsub(Regexp.new(letter,"i"),""))}
puts lengths
puts lengths.min
