def parse(dep)
	/Step (?<one>\w+) must be finished before step (?<two>\w+)/ =~ dep
	return [one, two]
end

dependencies = readlines.map {|dep| parse(dep)}

sequence = ""
complete = []
begin
	firsts = dependencies.collect(&:first)
	lasts = dependencies.map(&:reverse).collect(&:first)
	ready = (firsts-lasts).uniq.sort
	if !ready.empty?
		sequence += ready[0]
		complete = dependencies.select {|dep| dep[0] == ready[0]}.map(&:reverse).collect(&:first)
		dependencies = dependencies.reject {|dep| dep[0] == ready[0]}
	end
end while !ready.empty?

puts sequence + complete.uniq.sort.join
