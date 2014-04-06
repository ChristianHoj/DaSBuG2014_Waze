require 'http_request.rb'
require 'json'
require 'hashie'


def fetch_waze_data
  uri = 'http://world.waze.com/rtserver/web/GeoRSS'
  params = {
    format: 'JSON',
    left: 24.799838,
    right: 21.043941,
    top: 57.467857,
    bottom: 56.415208
  }
  json_string = HttpRequest.get(url: uri, parameters: params).body
  # hash = JSON.parse json_string
  # msg = Hashie::Mash.new hash
  # jams = msg.jams
  # alerts = msg.alerts
  # irregularities = msg.irregularities

  File.open("waze/#{Time.now.to_i}.txt", "w") do |f|
    f.puts json_string
  end
end


stop_time = Time.now + 24*60*60
while stop_time > Time.now
  fetch_waze_data
  sleep 10*60
end
