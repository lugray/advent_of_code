require 'set'

class MyString
  attr_accessor :str
  def initialize(str)
    @str = str
  end
  def to_s
    @str
  end
  def ==(other)
    @str == other.str
  end
  alias_method :eql?, :==
  def hash
    @str.hash
  end
  def <=>(other)
    (@str.length <=> other.str.length).nonzero? || @str <=> other.str
  end
end

s = SortedSet.new

s << MyString.new("abc")
s << MyString.new("a")
s << MyString.new("de")
s << MyString.new("fg")
puts s.map {|x| x.str}.join(", ")
e = s.first
s.delete(e)
puts s.map {|x| x.str}.join(", ")
e = s.first
s.delete(e)
puts s.map {|x| x.str}.join(", ")
e = s.first
s.delete(e)
puts s.map {|x| x.str}.join(", ")
