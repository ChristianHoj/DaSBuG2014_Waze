require 'sinatra'
require 'http_request.rb'
require 'json'
require 'hashie'

get '/' do
  @waze = fetch_waze_data
  erb :leafletdemo
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
  json_string = HttpRequest.get(url: uri, parameters: params).body
  hash = JSON.parse json_string
  msg = Hashie::Mash.new hash
  jams = msg.jams
  alerts = msg.alerts
  irregularities = msg.irregularities
end
