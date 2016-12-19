class Decompress
  PARTIAL_MARKER = /^\((\d+(x(\d+)?)?)?$/
  FULL_MARKER = /\(\d+x\d+\)/
  def initialize(input)
    @input = input.split(' ').join
  end

  def decrypt
    result = ""
    maybe_marker = ""
    pointer = @input.each_char
    loop do
      next_char = pointer.next
      maybe_marker += next_char
      if FULL_MARKER =~ maybe_marker
        result += process_marker(maybe_marker, pointer)
        maybe_marker = ""
      elsif !(PARTIAL_MARKER =~ maybe_marker)
        result += maybe_marker
        maybe_marker = ""
      end
    end
    result + maybe_marker
  end

  def full_decrypt_length
    single_decrypt = decrypt
    if new_start = FULL_MARKER =~ single_decrypt
      @input = single_decrypt[new_start, single_decrypt.length]
      new_start + full_decrypt_length
    else
      single_decrypt.length
    end
  end

  def length_of(string = @input) #Fails on '(6x2)(2x2)AA' and '(6x2)A(6x2)'
    if match_data = FULL_MARKER.match(string)
      marker_pos = match_data.begin(0)
      marker = match_data[0]
      num_chars, repeat_count = *marker.scan(/\d+/).map(&:to_i)
      marker_pos + repeat_count * length_of(string[marker_pos+marker.length,num_chars]) + length_of(string[marker_pos+marker.length+num_chars,string.length])
    else
      return 0 if string.nil?
      string.length
    end
  end

  def process_marker(marker, pointer)
    num_chars, repeat_count = *marker.scan(/\d+/).map(&:to_i)
    repeat_string = ""
    num_chars.times { repeat_string += pointer.next }
    repeat_string * repeat_count
  end
end

puts Decompress.new(File.open(File.dirname(__FILE__) + '/input.txt').read).decrypt.length
puts Decompress.new(File.open(File.dirname(__FILE__) + '/input.txt').read).length_of
