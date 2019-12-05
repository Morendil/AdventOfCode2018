require 'json'

input = readlines.map(&:strip)
samples = input.each_slice(4).select {|slice| slice[0] =~ /Before/}

samples = samples.map do |raw|
	sample = []
	/Before: (?<data>.*)/ =~ raw[0]
	sample << JSON.parse(data)
	/After: (?<data>.*)/ =~ raw[2]
	sample << JSON.parse(data)
	sample << raw[1].split(" ").map(&:to_i)
end

plus = lambda {|a,b| a+b}
mult = lambda {|a,b| a*b}
band = lambda {|a,b| a&b}
bor = lambda {|a,b| a|b}
id = lambda {|a,b| a}
gt = lambda {|a,b| a>b ? 1 : 0}
eq = lambda {|a,b| a==b ? 1 : 0}

opcodes = [
	['addr', ["R","R"], plus],
	['addi', ["R","I"], plus],
	['mulr', ["R","R"], mult],
	['mulu', ["R","I"], mult],
	['banr', ["R","R"], band],
	['bani', ["R","I"], band],
	['borr', ["R","R"], bor],
	['bori', ["R","I"], bor],
	['setr', ["R","I"], id],
	['seti', ["I","I"], id],
	['gtir', ["I","R"], gt],
	['gtri', ["R","I"], gt],
	['gtrr', ["R","R"], gt],
	['eqir', ["I","R"], eq],
	['eqri', ["R","I"], eq],
	['eqrr', ["R","R"], eq],
]

def execute_opcode(opcode, input, registers)
	name, modes, effect = opcode
	input_a = modes[0] == "R" ? registers[input[0]] : input[0]
	input_b = modes[1] == "R" ? registers[input[1]] : input[1]
	result = effect.call(input_a, input_b)
	registers[input[2]] = result
end

def sample_matches(sample, opcode)
	input = sample[2][1..-1]
	registers = sample[0].dup
	execute_opcode(opcode, input, registers)
	return registers == sample[1]
end

matches = {}
samples.each_with_index do |sample, index|
	opcodes.each do |opcode|
		if sample_matches(sample, opcode)
			matches[index] = (matches[index] || []) + [opcode[0]]
		end
	end
end
# p matches
p matches.select {|k,v| v.length >= 3}.length
