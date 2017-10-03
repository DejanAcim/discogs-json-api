require 'json'
require 'faraday'
require 'awesome_print'

conn = Faraday.new(:url => 'https://api.discogs.com') do |faraday|
  faraday.request  :url_encoded             # form-encode POST params
  faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  faraday.authorization :Discogs, "key=jOUDsbzZVnrDNJmDPIeF, secret=enter_your_secret_here"
end

response = conn.get '/database/search', {q: "2pac all eyez on me"} do |request|
	request.headers['Content-Type'] = "application/json"
end
body = response.body

json = JSON.parse(body)
ap json
puts json.class
