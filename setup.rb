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

  def initialize(main_dir, year, day, http, headers)
    @dir = File.join(main_dir, year.to_s, sprintf('day%02d', day))
    @day = day
    @year = year
    @http = http
    @headers = headers
  end

  def run
    mkdir
    get_input
  end

  def mkdir
    Dir.mkdir(dir)
    rescue Errno::EEXIST
  end

  def needs_input?
    return false if Time.new(year, 12, day) > Time.now
    !(File.exist?(input_file) || File.exist?(input_file + '.txt'))
  end

  def get_input
    return unless needs_input?
    puts "Getting input for day #{day}, in #{year}"
    resp = http.get("/#{year}/day/#{day}/input", headers)
    File.write(input_file, resp.body)
  end

  def input_file
    File.join(dir, 'input')
  end
end

Setup.new(__dir__).run
