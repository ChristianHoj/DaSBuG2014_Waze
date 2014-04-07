require 'json'
require 'hashie'

mercator = IO.read("waze/1396867493_mercator.txt")
hash = JSON.parse mercator
msg = Hashie::Mash.new hash
File.open("proj_input", "w") do |f|
  msg.irregularities.each do |irr|
    irr.line.each do |line|
      f.puts line.y.to_s + ' ' + line.x.to_s      
    end
  end
end

`proj +proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=6378137 +b=6378137 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs -I  -f ’%.9f’ proj_input > proj_output`
