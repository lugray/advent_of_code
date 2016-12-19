require 'digest'

class AdventCoin
  def initialize(input)
    @input = input
  end

  def first_coin(l = 5)
    (1..Float::INFINITY).find do |i|
      md5.hexdigest(@input + i.to_s)[0, l] == '0' * l
    end
  end

  def md5
    @md5 = Digest::MD5
  end
end

advent_coin = AdventCoin.new('ckczppom')
puts advent_coin.first_coin
puts advent_coin.first_coin(6)
