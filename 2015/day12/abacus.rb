require 'json'

class Array
  def silly_sum(ignore_red = false)
    self.map{ |el| el.silly_sum(ignore_red) }.inject(:+)
  end
end

class Hash
  def silly_sum(ignore_red = false)
    return 0 if ignore_red && self.values.include?("red")
    self.values.silly_sum(ignore_red)
  end
end

class String
  def silly_sum(_)
    0
  end
end

class Fixnum
  def silly_sum(_)
    self
  end
end

puts JSON.parse(File.open(File.dirname(__FILE__) + '/input.txt').read).silly_sum
puts JSON.parse(File.open(File.dirname(__FILE__) + '/input.txt').read).silly_sum(true)