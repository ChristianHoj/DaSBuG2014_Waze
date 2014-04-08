#!/usr/bin/env ruby
# encoding: utf-8

require "csv"

mercator_file = ARGV[0]
wgs84_out_file = ARGV[1]
tmp_file = "proj_tmp"
tmp_wgs84_file = "proj_wgs84_tmp"

# Extract locations from input file and write them to a temporary file
File.open(tmp_file, "w") do |f|
  CSV.foreach mercator_file, {col_sep:"\t"} do |row|
    if row[1].nil?
      f.puts "\n"
    else
      row1 = row[1].sub(',', '.')
      row2 = row[2].sub(',', '')
      f.puts "#{row1}\t#{row2}\n"
    end
  end
end

# Invoke the proj.4 command to convert from the Waze Mercator projection to WGS84 used by Leaflet, Google maps and others
%x{proj +proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=6378137 +b=6378137 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs -I -f '%.9f' #{tmp_file} > #{tmp_wgs84_file}}

line = 0
converted = CSV.read tmp_wgs84_file, {col_sep:"\t"}
CSV.open(wgs84_out_file, "w", {col_sep:"\t"}) do |outfile|
  CSV.foreach mercator_file, {col_sep:"\t"} do |row|
    row[1] = converted[line][0]
    row[2] = converted[line][1]
    outfile << row
    line += 1
  end
end


# Remove the temporary files
# File.delete tmp_file
# File.delete tmp_wgs84_file
