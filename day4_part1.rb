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
		guard_minutes[state] = (guard_minutes[state] || []) + [m]
		minutes[previous] = guard_minutes
	end if previous
	start = stop == 60 ? 0 : stop
	previous = guard if guard
end

most_asleep = minutes.max {|a,b| (a[1]["#"] || []).length <=> (b[1]["#"] || []).length}
guard = most_asleep[0]
minutes = most_asleep[1]["#"]
minute = minutes.group_by(&:itself).max{|a,b| a[1].length <=> b[1].length}[0]
puts "#{guard}*#{minute}=#{guard.to_i*minute}"
