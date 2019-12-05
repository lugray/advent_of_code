#!/usr/bin/env ruby

Dir.glob(File.join(File.dirname(__FILE__), 'day??.rb')).each do |f|
  basename = File.basename(f, '.rb')
  outfile = "#{basename}.output"
  next if File.exist?(outfile)
  require_relative basename
  File.write(outfile, Object.const_get(basename.capitalize).output)
end
