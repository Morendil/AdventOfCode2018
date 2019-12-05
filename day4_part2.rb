events = readlines.sort

minutes = {}
previous = nil
start = 0
stop = 0
state = "."
events.each do |event|
	guard = nil
	case event
	when /\[1518-\d+-\d+ (?<hour>\d+):(?<min>\d+)\] Guard #(?<guard>\d+) begins shift/
		guard = $~[:guard]
		state = "."
	when /\[1518-\d+-\d+ (?<hour>\d+):(?<min>\d+)\] falls asleep/
		state = "."
	when /\[1518-\d+-\d+ (?<hour>\d+):(?<min>\d+)\] wakes up/
		state = "#"
	end
	stop = ($~[:hour] == "00") ? $~[:min].to_i : 60

	(start..(stop-1)).each do |m|
		guard_minutes = minutes[previous] || {}
		guard_minutes[m] = (guard_minutes[m] || 0) + 1 if state == "#"
		minutes[previous] = guard_minutes
	end if previous
	start = stop == 60 ? 0 : stop
	previous = guard if guard
end

minutes = minutes.map {|k,v| [k, v.max {|a,b| a[1] <=> b[1]}]}.to_h
minutes = minutes.reject{|k,v| v.nil?}
most_asleep = minutes.max {|a,b| a[1][1] <=> b[1][1]}
guard = most_asleep[0]
minute = most_asleep[1][0]
puts "#{guard}*#{minute}=#{guard.to_i*minute}"
