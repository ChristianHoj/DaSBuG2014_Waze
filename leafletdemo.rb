require 'sinatra'

get '/' do
  erb :leafletdemo
end

get '/timelapse' do
  @wazes = []
  @timestamps = []
  files = Dir['waze/*.txt']
  files.each { |f|
    @wazes << IO.read(f)
    @timestamps << Time.at(f[5, 10].to_i).strftime("%a, %b %d %Y, %X")
  }
  erb :timelapse
end
