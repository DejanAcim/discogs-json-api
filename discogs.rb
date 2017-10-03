require 'json'
require 'faraday'
require 'awesome_print'

conn = Faraday.new(:url => 'https://api.discogs.com') do |faraday|
  faraday.request  :url_encoded
  faraday.adapter  Faraday.default_adapter
  faraday.authorization :Discogs, "key=jOUDsbzZVnrDNJmDPIeF, secret=enter_your_secret_here"
end

response = conn.get '/database/search', {q: "2pac all eyez on me"} do |request|
	request.headers['Content-Type'] = "application/json"
end
body = response.body

json = JSON.parse(body)
results = json["results"]
release = results.find { |e| e["type"] == "release" && e["format"].include?("CD") && e["format"].include?("Album") }

url = release["resource_url"]
puts url

response = conn.get(url)
album = JSON.parse(response.body)

puts "Tytuł: #{album["title"]}"
puts "Artysta: #{album["artists"].first["name"]}"
puts "Gatunek: #{album["genres"].join(", ")}"
puts "Styl: #{album["styles"].join(". ")}"
puts "Lista utworów:"
album["tracklist"].each do |track|
	puts "#{track["position"]}\t[#{track["duration"]}]\t#{track["title"]}"
end
