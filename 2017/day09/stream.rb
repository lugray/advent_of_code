class String
  def ignoring_garbage
    return ignoring_garbage { |_| nil } unless block_given?
    in_garbage = false
    ignore_next = false
    garbage_total = 0
    each_char do |char|
      if char == '<' && !in_garbage
        in_garbage = true
        next
      end
      yield char unless in_garbage
      next unless in_garbage
      if ignore_next
        ignore_next = false
      elsif char == '!'
        ignore_next = true
      elsif char == '>'
        in_garbage = false
      else
        garbage_total += 1
      end
    end
    garbage_total
  end
end

input = File.read(File.dirname(__FILE__) + '/input').chomp

score_level = 0
total = 0
garbage_total = input.ignoring_garbage do |char|
  case char
  when '{'
    score_level += 1
    total += score_level
  when '}'
    score_level -= 1
  end
end
puts total
puts garbage_total