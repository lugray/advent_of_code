class CorporatePolicy

  STRAIGHTS = ('a'.ord..'z'.ord).map(&:chr).join.scan(/(?=(...))/).map(&:first).reject do |straight|
    ["i", "o", "l"].any?{ |l| straight[l] }
  end

  def initialize(current_pass)
    @current_pass = current_pass
  end

  def next_pass
    candidate = next_candidate
    until allowed_pass(candidate)
      candidate = next_candidate(candidate)
    end
    candidate
  end

  def allowed_pass(password)
    STRAIGHTS.any? { |straight| password[straight] } &&
    ["i", "o", "l"].none? { |l| password[l] } &&
    password.scan(/(.)\1/).length >= 2
  end

  private

  def next_candidate(current = @current_pass)
    try = current.next
    while i = try.index(/[iol]/)
      try = try[0, i + 1].next.ljust(@current_pass.length, 'a')
      while try.scan(/(.)\1/).length < 2
        if try[-2] != try[-1]
          if try[-2] < try[-1]
            try[-2] = try[-2].next
          end
          try[-1] = try[-2]
        elsif try[-4] != try[-3]
          if try[-4] < try[-3]
            try[-4] = try[-4].next
          end
          try[-3] = try[-4]
        end
      end
    end
    try
  end
end

corporate_policy = CorporatePolicy.new('vzbxkghb')
puts first = corporate_policy.next_pass
corporate_policy = CorporatePolicy.new(first)
puts corporate_policy.next_pass

