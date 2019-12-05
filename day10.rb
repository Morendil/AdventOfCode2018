def parse(particle)
	/position=< *(?<x>-?\d+), *(?<y>-?\d+)> velocity=< *(?<dx>-?\d+), *(?<dy>-?\d+)>/ =~ particle
	return [[x, y].map(&:to_i), [dx, dy].map(&:to_i)]
end

def step(particle)
	[particle[0].zip(particle[1]).map {|p| p[0]+p[1]}, particle[1]]
end

def area(particles)
	positions = particles.collect(&:first)
	xs = positions.collect(&:first)
	ys = positions.map(&:reverse).collect(&:first)
	(xs.max-xs.min).abs * (ys.max-ys.min).abs
end

def display(particles)
	positions = particles.collect(&:first)
	xs = positions.collect(&:first)
	ys = positions.map(&:reverse).collect(&:first)
	(ys.min..ys.max).each do |y|
		line = particles.select {|p| p[0][1] == y}
		(xs.min..xs.max).each do |x|
			dot = line.select {|p| p[0][0] == x}
			print dot.empty? ? "." : "#"
		end
		print "\n"
	end
end

seconds = 0
particles = readlines.map {|particle| parse(particle)}
area_min = area(particles)
particles_min = particles
begin
	particles_next = particles.map {|p| step(p)}
	area_next = area(particles_next)
	if area_next < area_min
		area_min = area_next
		particles_min = particles_next
		stop = false
		seconds += 1
	else
		stop = true
	end
	particles = particles_next
end while !stop
display(particles_min)
p seconds
