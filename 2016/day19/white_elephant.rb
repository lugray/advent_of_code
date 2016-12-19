module WhiteElephant
  def self.josephus_elf(n)
    2*n - 2**n.bit_length + 1
  end

  def self.across_elf(n)
    if /^10+$/ =~ n.to_s(3)
      n
    elsif n.to_s(3)[0] == "1"
      n - 3**Math.log(n,3).floor
    else
      2*n - 3**Math.log(n,3).ceil
    end
  end
end

puts WhiteElephant::josephus_elf(3014387)
puts WhiteElephant::across_elf(3014387)
