require 'json'
require 'faraday'
require 'awesome_print'

conn = Faraday.new(:url => 'https://api.discogs.com') do |faraday|
  faraday.request  :url_encoded             # form-encode POST params
  faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
end

## GET ##

response = conn.get '/releases/249504'     # GET http://sushi.com/nigiri/sake.json
body = response.body

json = JSON.parse(body)
ap json
puts json.class
