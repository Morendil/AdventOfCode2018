inputs = readlines.map(&:to_i).cycle
reached = [0]
twice = false
until twice do
  last = reached[-1]+inputs.next
  twice = reached.include?(last)
  reached << last
end
puts last
