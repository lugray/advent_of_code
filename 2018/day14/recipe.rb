#!/usr/bin/env ruby

class Ring
  attr_reader :value

  def initialize(value)
    @value = value
    @next = self
    @prev = self
  end

  def insert(value)
    to_insert = Ring.new(value)
    after = @next
    @next = to_insert
    to_insert.prev = self
    to_insert.next = after
    after.prev = to_insert
    to_insert
  end

  def remove
    @next.prev = @prev
    @prev.next = @next
    @prev = nil
    @next = nil
    @value
  end

  def next(n = 1)
    return @next if n == 1
    ret = self
    n.times do
      ret = ret.next
    end
    ret
  end

  def prev(n = 1)
    return @prev if n == 1
    ret = self
    n.times do
      ret = ret.prev
    end
    ret
  end

  def to_a(n = nil)
    arr = [self.value]
    cur = @next
    while n.nil? ? cur != self : arr.length < n do
      arr << cur.value
      cur = cur.next
    end
    arr
  end

  protected

  attr_writer :next, :prev
end

def ten_after(n)
  head = elf1 = Ring.new(3)
  elf2 = elf1.insert(7)
  count = 2
  loop do
    (elf1.value + elf2.value).digits.reverse.each do |d|
      head.prev.insert(d)
      count +=1
      return head.prev(10).to_a(10).join if count == n + 10
    end
    elf1 = elf1.next(elf1.value+1)
    elf2 = elf2.next(elf2.value+1)
  end
end

# Slow 😞
def count_til(n)
  n = n.digits.reverse
  head = elf1 = Ring.new(3)
  elf2 = elf1.insert(7)
  count = 2
  last = Array.new(n.length - 2) + [3, 7]
  loop do
    (elf1.value + elf2.value).digits.reverse.each do |d|
      head.prev.insert(d)
      count +=1
      last.push(d).shift
      return count - n.length if n == last
    end
    elf1 = elf1.next(elf1.value+1)
    elf2 = elf2.next(elf2.value+1)
  end
end

puts ten_after(110201)

puts count_til(110201)
