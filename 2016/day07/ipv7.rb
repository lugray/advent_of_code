class IPv7
  ABBA_DETECTOR = /(.)(?!\1)(.)\2\1/
  ABA_DETECTOR = /(?=((.)(?!\2).\2))/

  def initialize(input)
    @input = input.each_line.map(&:strip).reject{ |line| line == "" }
  end

  def has_abba(str)
    !(ABBA_DETECTOR =~ str).nil?
  end

  def supernets(ip)
    ip.split(/\[[^\[\]]*\]/)
  end

  def hypernets(ip)
    ip.split(/(^|\])[^\[\]]*(\[|$)/)
  end

  def abas_in(str)
    str.scan(ABA_DETECTOR).map(&:first)
  end

  def count_tls
    @input.count do |ip|
      supernet_has_abba = supernets(ip).any?{ |part| has_abba(part) }
      hypernet_has_no_abba = !hypernets(ip).any?{ |part| has_abba(part) }
      supernet_has_abba && hypernet_has_no_abba
    end
  end

  def count_ssl
    @input.count do |ip|
      abas = supernets(ip).map{ |part| abas_in(part) }.flatten
      babs = abas.map { |aba| aba[1] + aba[0] + aba[1] }
      hypernets(ip).any?{ |part| babs.any? { |bab| part[bab] } }
    end
  end
end

puts IPv7.new(File.open(File.dirname(__FILE__) + '/input.txt').read).count_tls
puts IPv7.new(File.open(File.dirname(__FILE__) + '/input.txt').read).count_ssl
