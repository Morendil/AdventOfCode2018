a = 1
b = (a == 1) ? 10551343 : 943
a = 0
f = 1
begin
	a = a + f if b % f == 0
	f = f + 1
end while f <= b
p a
