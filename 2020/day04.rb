#!/usr/bin/env ruby

require_relative 'day'

class Passport
  REQUIRED_FIELDS = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

  def initialize(input)
    @fields = input.split(/\s+/).map { |f| f.split(':') }.to_h
  end

  def valid?
    REQUIRED_FIELDS.all? { |f| @fields.key?(f) }
  end

  def strict_valid?
    valid? &&
      @fields['byr'].to_i.between?(1920, 2002) &&
      @fields['iyr'].to_i.between?(2010, 2020) &&
      @fields['eyr'].to_i.between?(2020, 2030) &&
      valid_height? &&
      /^#[0-9a-f]{6}$/ === @fields['hcl'] &&
      ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].include?(@fields['ecl']) &&
      /^[0-9]{9}$/ === @fields['pid']
  end

  def valid_height?
    case @fields['hgt']
    when /^(\d+)cm$/
      $1.to_i.between?(150, 193)
    when /^(\d+)in$/
      $1.to_i.between?(59, 76)
    else
      false
    end
  end
end

class Day04 < Day
  def initialize
    @passports = input.split("\n\n").map { |p| Passport.new(p) }
  end

  def part_1
    @passports.count(&:valid?)
  end

  def part_2
    @passports.count(&:strict_valid?)
  end
end

Day04.run if __FILE__ == $0
