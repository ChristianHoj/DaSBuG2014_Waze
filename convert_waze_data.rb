#!/usr/bin/env ruby
# encoding: utf-8

require "csv"

usage = %{
convert_waze_data will convert Waze data collected with Mercator projection to WGS84 projection used by the GPS system.

Script usage:
convert_waze_data.rb <input file> <output file> <column index for first coordinate column>
}

abort usage if ARGV.length != 3

mercator_file = ARGV[0]
wgs84_out_file = ARGV[1]
col = ARGV[2].to_i
tmp_file = "proj_tmp"
tmp_wgs84_file = "proj_wgs84_tmp"

# Extract locations from input file and write them to a temporary file
line = 1
File.open(tmp_file, "w") do |f|
  CSV.foreach mercator_file, {col_sep:"\t", encoding:"BOM|UTF-16LE:UTF-8"} do |row|
    print "Reading line #{line}\r"
    if row[col].nil? || !row[col].include?(',')
      f.puts "\n"
    else
      row1 = row[col].sub(',', '.')
      row2 = row[col+1].sub(',', '')
      f.puts "#{row1}\t#{row2}\n"
    end
    line += 1
  end
end
print "\n"

puts "Converting coordinates using Proj.4"
# Invoke the proj.4 command to convert from the Waze Mercator projection to WGS84 used by Leaflet, Google maps and others
%x{proj +proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=6378137 +b=6378137 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs -I -f '%.9f' #{tmp_file} > #{tmp_wgs84_file}}

puts "Writing results"
line = 0
converted = CSV.read tmp_wgs84_file, {col_sep:"\t"}
CSV.open(wgs84_out_file, "w", {col_sep:"\t"}) do |outfile|
  CSV.foreach mercator_file, {col_sep:"\t", encoding:"BOM|UTF-16LE:UTF-8"} do |row|
    if !row[col].nil? && row[col].include?(',')
      row[col] = converted[line][0]
      row[col+1] = converted[line][1]
    end
    outfile << row
    line += 1
  end
end


# Remove the temporary files
File.delete tmp_file
File.delete tmp_wgs84_file
