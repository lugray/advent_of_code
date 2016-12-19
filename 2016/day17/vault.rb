require 'digest'

class Vault
  def initialize(input)
    @input = input
    @md5 ||= Digest::MD5.new
    @max_soln_found = ''
  end

  def position(path)
    pos = [1, 1]
    path.each_char do |char|
      case char
      when 'U'
        pos[1] -=1
      when 'D'
        pos[1] +=1
      when 'L'
        pos[0] -= 1
      when 'R'
        pos[0] += 1
      end
      return nil if out_of_bounds(pos)
    end
    pos
  end

  def out_of_bounds(pos)
    pos.first > 4 || pos.first < 1 || pos.last > 4 || pos.last < 1
  end

  def allowed(path)
    @md5.hexdigest(@input + path)[0,4].each_char.zip(['U', 'D', 'L', 'R']).reject do |pair|
      /[\da]/ =~ pair.first || !position(path + pair.last)
    end.map(&:last).map { |next_move| path + next_move }
  end

  def get_paths(from=[''])
    return nil if from == []
    if final_path = from.find { |path| position(path)==[4, 4] }
      return final_path
    end
    get_paths(from.map{ |path| allowed(path) }.flatten(1))
  end

  def get_long_path(from=[''])
    return @max_soln_found.length if from == []
    if working_path = from.find{ |path| position(path)==[4, 4] }
      @max_soln_found = working_path
    end

    next_set = from.reject{ |path| position(path)==[4, 4] }.map { |path| allowed(path) }.flatten(1)
    get_long_path(next_set)
  end
end

puts Vault.new('yjjvjgan').get_paths
puts Vault.new('yjjvjgan').get_long_path
