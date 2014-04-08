#!/usr/bin/env ruby
# encoding: utf-8

require 'json'
require 'hashie'

mercator_file = ARGV[0]
wgs84_out_file = ARGV[1]
tmp_file = "proj_tmp"

# Extract locations from input file and write them to a temporary file
mercator = IO.read(mercator_file)
hash = JSON.parse mercator
msg = Hashie::Mash.new hash
File.open(tmp_file, "w") do |f|
  msg.irregularities.each do |irr|
    irr.line.each do |line|
      f.puts line.y.to_s + ' ' + line.x.to_s
    end
  end
end

# Invoke the proj.4 command to convert from the Waze Mercator projection to WGS84 used by Leaflet, Google maps and others
%x{proj +proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=6378137 +b=6378137 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs -I -f '%.9f' #{tmp_file} > #{wgs84_out_file}}

# Remove the temporary file
File.delete tmp_file
