#!/usr/bin/env ruby

require 'net/http'
require 'nokogiri'
require 'fileutils'

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
    @headers ||= {
      'Cookie' => File.read(File.join(dir, 'cookies')).chomp,
      'User-Agent' => 'https://github.com/lugray/advent_of_code/blob/main/setup.rb by lisa.ugray@gmail.com',
    }
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

  def run
    return if Time.new(year, 12, day) > Time.now
    unless File.exist?(input_file)
      print_day
      puts "  Input"
      resp = http.get("/#{year}/day/#{day}/input", headers)
      File.write(input_file, resp.body)
    end
    unless File.exist?(example_input_file)
      FileUtils.touch(example_input_file)
      print_day
      puts "  Example Input"
      resp = http.get("/#{year}/day/#{day}", headers)
      document = Nokogiri::HTML.parse(resp.body)
      document.css('pre code').each_with_index do |code, i|
        File.write(example_input_file(i), code.text)
      end
    end
    return if Time.new(year, 12, 30) < Time.now # Don't generate for previous years
    unless File.exist?(day_file)
      print_day
      puts "  Template"
      File.write(day_file, File.read(template_file).gsub('###', day.to_s.rjust(2, '0')))
      File.chmod(0755, day_file)
    end
  end

  def print_day
    return if @printed_day
    puts "Day #{day}, #{year}"
    @printed_day = true
  end

  def input_file
    File.join(dir, year.to_s, sprintf('day%02d.input', day))
  end

  def example_input_file(i = 0)
    suffix = i == 0 ? '' : ".#{i}"
    File.join(dir, year.to_s, sprintf("day%02d.example#{suffix}", day))
  end

  def day_file
    File.join(dir, year.to_s, sprintf('day%02d.rb', day))
  end

  def template_file
    File.join(dir, 'day_template.rb')
  end
end

Setup.new(__dir__).run
