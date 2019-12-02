#!/usr/bin/env ruby

require 'net/http'

class Setup
  attr_reader :dir
  def initialize(dir)
    @dir = Dir.new(dir)
  end

  def run
    dir.each.select {|year| /\d{4}/ =~ year}.map(&:to_i).each do |year|
      (1..25).each do |day|
        SetupDay.new(dir, year, day, http, headers).run
      end
    end
  end

  def headers
    @headers ||= {'Cookie' => File.read(File.join(dir, 'cookies')).chomp}
  end

  def http
    @http ||= Net::HTTP.start('adventofcode.com', 443, use_ssl: true)
  end
end

class SetupDay
  attr_reader :dir, :year, :day, :http, :headers

  def initialize(dir, year, day, http, headers)
    @dir = dir
    @day = day
    @year = year
    @http = http
    @headers = headers
  end

  def needs_input?
    return false if Time.new(year, 12, day) > Time.now
    !File.exist?(input_file)
  end

  def run
    return unless needs_input?
    puts "Getting input for day #{day}, in #{year}"
    resp = http.get("/#{year}/day/#{day}/input", headers)
    File.write(input_file, resp.body)
  end

  def input_file
    File.join(dir, year.to_s, sprintf('day%02d.input', day))
  end
end

Setup.new(__dir__).run
