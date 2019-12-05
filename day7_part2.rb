def parse(dep)
	/Step (?<one>\w+) must be finished before step (?<two>\w+)/ =~ dep
	return [one, two]
end

dependencies = readlines.map {|dep| parse(dep)}

help = 5
offset = 4
workers = (1..help).map {[".", 0]}
time = 0
queued = []
firsts = dependencies.collect(&:first)
lasts = dependencies.map(&:reverse).collect(&:first)
remain = (firsts+lasts).uniq.sort
begin
	if !queued.empty?
		step, ends = queued[0]
		queued.select {|task| task[1] == ends}.each do |task|
			dependencies = dependencies.reject {|dep| dep[0] == task[0]}
			remain = remain.reject {|step| step == task[0]}
		end
		queued = queued.reject {|task| task[1] == ends}
		time = ends
	end
	p time
	firsts = dependencies.collect(&:first)
	lasts = dependencies.map(&:reverse).collect(&:first)
	ready = (firsts-lasts).uniq.sort
	ready = remain if ready.empty?
	p ready
	assign = ready - queued.collect(&:first)
	p assign
	workers.each_with_index do |worker, index|
		step, free = worker
		next if time < free
		if !assign.empty?
			next_step = assign.delete_at(0)
			workers[index] = [next_step, time+next_step.ord-offset]
			queued << workers[index]
		else
			workers[index] = [".", time]
		end
	end
	p workers.sort{|a,b| a[0] <=> b[0]}
	queued = queued.sort{|a,b| a[1] <=> b[1]}
	p queued
end while !ready.empty?
p time
