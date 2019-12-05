squares = {}

claims = readlines
claims.each do |claim|
	/#(?<id>\d+) @ (?<left>\d+),(?<top>\d+): (?<width>\d+)x(?<height>\d+)/ =~ claim
	((top.to_i+1)..(top.to_i+height.to_i)).each do |y|
		((left.to_i+1)..(left.to_i+width.to_i)).each do |x|
			claimed_by = (squares[[x,y]] or []) + [id]
			squares[[x,y]] = claimed_by
		end
	end
end

overlaps = squares.select {|k,v| v.length >= 2}
puts overlaps.length

overlapping = overlaps.values.flatten.uniq

claim_ids = (1..claims.length).to_a
remaining = claim_ids - overlapping.map(&:to_i)
puts remaining
