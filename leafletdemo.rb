require 'sinatra'
require 'http_request.rb'

get '/' do
  erb :leafletdemo
end

get '/timelapse' do
  @waze = IO.read('waze/1396712892.txt')
  erb :timelapse
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
  HttpRequest.get(url: uri, parameters: params).body
end
