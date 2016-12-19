class Triangler
  def count_allowed_rows(input)
    count_allowed(normalize_input(input))
  end

  def count_allowed_cols(input)
    count_allowed(normalize_input(input).each_slice(3).to_a.map(&:transpose).flatten(1))
  end

  def count_allowed(table)
    table.keep_if { |tri_spec| allowed?(tri_spec) }.length
  end

  def normalize_input(input)
    input.split(/$/).map { |tri_spec| tri_spec.split.map(&:to_i)}.keep_if { |numbers| numbers.length == 3 }
  end

  def allowed?(numbers)
    max = numbers.max
    numbers.inject(:+) > 2 * max
  end
end

puts Triangler.new.count_allowed_rows(File.open(File.dirname(__FILE__) + '/input.txt').read)
puts Triangler.new.count_allowed_cols(File.open(File.dirname(__FILE__) + '/input.txt').read)
