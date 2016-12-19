require 'digest'

class KeyGen
  def initialize(salt, klass = Digest::MD5)
    @klass = klass
    @salt = salt
    @stream = 1000.times.map { |i| md5.hexdigest(@salt + i.to_s) }
    @next_num = 0
  end

  def next_in_stream
    @stream.push(md5.hexdigest(@salt + (@next_num + 1000).to_s))
    @next_num = @next_num + 1
    @stream.shift
  end

  def next_candidate
    begin
      next_possible = next_in_stream
    end while !(/(.)\1\1/ =~ next_possible)
    next_possible
  end

  def next_key
    begin
      next_possible = next_candidate
      position = /(.)\1\1/ =~ next_possible
      search = next_possible[position] * 5
    end while !@stream.any? { |candidate| candidate[search] }
    [@next_num-1, next_possible]
  end

  def ans
    63.times { next_key }
    next_key.first
  end

  def md5
    @md5 ||= @klass.new
  end

  class StretchMD5
    def initialize
      @md5 ||= Digest::MD5.new
    end

    def hexdigest(str, count = 2017)
      return str if count == 0
      hexdigest(@md5.hexdigest(str), count-1)
    end
  end
end

puts KeyGen.new('zpqevtbw').ans
puts KeyGen.new('zpqevtbw', KeyGen::StretchMD5).ans
