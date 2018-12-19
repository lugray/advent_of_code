#!/usr/bin/env ruby
#
#           #ip 3
#           addi 3 16 3 Goto a
# c:        seti 1 8 1  r1 = 1
# e:        seti 1 3 4  r4 = 1
# b:        mulr 1 4 2  r2 = r1 * r4
#           eqrr 2 5 2
#           addr 2 3 3  Jump by reg 2 (0 or 1) skip next if r2==r5
#           addi 3 1 3  Goto d
#           addr 1 0 0  r0 += r1
# d:        addi 4 1 4  r4 += 1
#           gtrr 4 5 2
#           addr 3 2 3  Jump by reg 2 (0 or 1) skip next if r4>r5
#           seti 2 6 3  Goto b
#           addi 1 1 1  r1 += 1
#           gtrr 1 5 2
#           addr 2 3 3  Jump by reg 2 (0 or 1) skip next if r1>r5
#           seti 1 5 3  Goto e
#           mulr 3 3 3  Exit
# a:        addi 5 2 5  r5 += 2
#           mulr 5 5 5  r5 = r5 * r5
#           mulr 3 5 5  r5 = r5 * r3
#           muli 5 11 5 r5 = 11 * r5
#           addi 2 5 2  r2 += 5
#           mulr 2 3 2  r2 = r2 * r3
#           addi 2 21 2 r2 += 21
#           addr 5 2 5  r5 += r2
#           addr 3 0 3  Jump by reg 0
#           seti 0 4 3  Goto c
#           setr 3 1 2  r2 := 27
#           mulr 2 3 2  r2 = r2 * 28
#           addr 3 2 2  r2 += 29
#           mulr 3 2 2  r2 = r2 * 30
#           muli 2 14 2 r2 = r2 * 14
#           mulr 2 3 2  r2 = r2 * 32
#           addr 5 2 5  r5 += r2
#           seti 0 3 0  r0 = 0
#           seti 0 6 3  Goto c
#
#
#
# r0=r1=r2=r3=r4=r5=0
# r0=1

# r5 = (r0 == 0 ? 967 : 10551367)
# r0 = 0
# r1 = 1
# loop do
#   r4 = 1
#   loop do
#     r0 += r1 if r1 * r4 == r5
#     r4 += 1
#     break if r4>r5
#   end
#   r1 += 1
#   break if r1>r5
# end
# puts r0


# n = 967
# n = 10551367
# res = 0
# (1..n).each do |i|
#   (1..n).each do |j|
#     res += i if i * j == n
#   end
# end
# puts res
#

def factor_sum(n)
  (1..n).select{ |i| n % i == 0 }.sum
end

puts factor_sum(967)
puts factor_sum(10551367)
