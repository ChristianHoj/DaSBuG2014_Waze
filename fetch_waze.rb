require 'http_request.rb'

def write_file(content)
  File.open("waze/#{Time.now.to_i}.json", 'w') do |f|
    f.puts json_string
  end
end

def fetch_waze_data
  uri = 'http://world.waze.com/rtserver/web/GeoRSS'
  params = {
    format: 'JSON',
    left: 24.799838,
    right: 21.043941,
    top: 57.467857,
    bottom: 56.415208
  }
  write_file HttpRequest.get(url: uri, parameters: params).body
end

stop_time = Time.now + 24 * 60 * 60
while stop_time > Time.now
  fetch_waze_data
  sleep 10 * 60
end
