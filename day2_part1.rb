def just(n, word)
	word.split("").group_by(&:itself).values.map(&:length).include? n
end

words = readlines
having_2 = words.count {|word| just(2, word)}
having_3 = words.count {|word| just(3, word)}

checksum = having_2 * having_3
puts checksum
