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
	['muli', ["R","I"], mult],
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

def execute_opcode(opcode, registers, input)
	name, modes, effect = opcode
	input_a = modes[0] == "R" ? registers[input[0]] : input[0]
	input_b = modes[1] == "R" ? registers[input[1]] : input[1]
	result = effect.call(input_a, input_b)
	registers[input[2]] = result
end

ip_register = readline.split(" ").last.to_i
program = readlines.map(&:strip).map {|instr| instr.split(" ")}
program = program.map {|code, *input| [opcodes.find_index {|op| op[0] == code}, input.map(&:to_i)]}

count = 0
registers = [1] + ([0] * 5)
ip = 0
begin
	old = registers.dup
	old_ip = ip
	instruction = program[ip]
	opcode = opcodes[instruction[0]]
	input = instruction[1]
	registers[ip_register] = ip
	execute_opcode(opcode, registers, input)
	ip = registers[ip_register] + 1
	done = (ip >= program.length) || (ip < 0)
# rescue SignalException
	puts "ip=#{old_ip} #{old} #{opcode[0]} #{input} #{registers}"
	# registers = old
	# ip = old_ip
	count += 1
	done = true if count > 500000
end until done
p registers
p count
