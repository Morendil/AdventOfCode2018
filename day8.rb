nodes = readlines[0].split(" ").map(&:to_i)

def parse(nodes)
	num_node = nodes[0]
	num_meta = nodes[1]
	consumed = 2
	children = []
	(1..num_node).each do |i|
		child = parse(nodes[consumed..-1])
		consumed += child[2]
		children << child
	end
	meta = nodes.slice(consumed, num_meta)
	consumed += num_meta
	[children, meta, consumed]
end

def sum_meta(tree)
	children, meta = tree
	meta.sum + children.map{|child| sum_meta(child)}.sum
end

def node_value(tree)
	children, meta = tree
	return meta.sum if children.empty?
	values = meta.map do |entry|
		if entry < 1 || entry > children.length
			0
		else
			node_value(children[entry-1])
		end
	end
	values.sum
end

tree = parse(nodes)
p sum_meta(tree)
p node_value(tree)
