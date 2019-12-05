cart_subs = {
	"^":["|",[0,-1],["<","^",">"],{"/":">","\\":"<"}],
	"v":["|",[0,1],[">","v","<"],{"/":"<","\\":">"}],
	">":["–",[1,0],["^",">","v"],{"/":"^","\\":"v"}],
	"<":["–",[-1,0],["v","<","^"],{"/":"v","\\":"^"}]
}

tracks = readlines.map {|line| line.split("")}

carts = []
tracks.each_with_index do |line, y|
	line.each_with_index do |square, x|
		if cart_subs[square.to_sym]
			carts << [x,y,square,0]
			line[x] = cart_subs[square.to_sym][0]
		end
	end
end

def show(tracks, carts)
	tracks = tracks.map(&:dup)
	carts.each do |cart|
		tracks[cart[1]][cart[0]]=cart[2]
	end
	tracks.map(&:join).join("\n")
end

def sorted(carts)
	carts.sort {|a,b| a[1] == b[1] ? a[0] <=> b[0] : a[1] <=> b[1]}
end

def tick(cart_subs, tracks, carts, cart)
	x, y, shape, state = cart
	# Don't process crashed; instantly stop if last non-crashed cart
	if (shape == "X")
		return cart
	end

	subs = cart_subs[shape.to_sym]
	cart[0] = x + subs[1][0]
	cart[1] = y + subs[1][1]
	under = tracks[cart[1]][cart[0]]
	if under == "+"
		cart[2] = subs[2][cart[3]]
		cart[3] = (cart[3]+1)%3
	elsif subs[3][under.to_sym]
		cart[2] = subs[3][under.to_sym]
	end
	if carts.any? {|other| other[0] == cart[0] && other[1] == cart[1] && other[2] != cart[2]}
		carts.select {|other| other[0] == cart[0] && other[1] == cart[1]}.each do |cart|
			cart[2] = "X"
		end
	end
	cart
end

begin
	sorted(carts).each {|cart| tick(cart_subs, tracks, carts, cart)}
	carts = carts.reject {|cart| cart[2] == "X"}
end until carts.length == 1

# puts show(tracks, carts)
p carts
