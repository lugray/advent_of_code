require 'digest'

class Enumerator::Lazy
  def filter_map
    Lazy.new(self) do |yielder, *values|
      result = yield *values
      yielder << result if result
    end
  end
end

class DoorCode
  def initialize(door_id)
    @door_id = door_id
  end

  def md5
    @md5 ||= Digest::MD5.new
  end

  def code
    (0..Float::INFINITY).each.lazy.map{ |val| md5.hexdigest(@door_id + val.to_s) }.filter_map { |digest| digest[5] if digest[0, 5] == '00000' }.first(8).join
  end

  def alt_code
    source = (0..Float::INFINITY).each.lazy.map{ |val| md5.hexdigest(@door_id + val.to_s) }.filter_map { |digest| digest[5,2] if digest[0, 5] == '00000' }
    code = Array.new(8)
    while code.any?(&:nil?)
      check = source.next
      pos = int_or_nil(check[0])
      char = check[1]
      if pos && pos < 8 && code[pos].nil?
        code[pos] = char
        puts code.map{|char| char || '_' }.join
      end
    end
    code.join
  end

  def int_or_nil(s)
    Integer(s)
  rescue ArgumentError
    nil
  end
end

puts DoorCode.new('reyedfim').code
puts DoorCode.new('reyedfim').alt_code
