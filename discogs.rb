require 'json'
require 'faraday'
require 'awesome_print'

class JSONClient
	def initialize(root_url)
		@root_url = root_url
	end

	def get(path, params = {})
		response = connection.get path, params do |request|
			request.headers['Content-Type'] = "application/json"
		end

		body = response.body
		json = JSON.parse(body)
		json
	end

	def authenticate(auth_type, auth_content)
		@authentication = [auth_type, auth_content]
	end

	private

	def connection
		@connection ||= Faraday.new(:url => @root_url) do |faraday|
		  faraday.request  :url_encoded
		  faraday.adapter  Faraday.default_adapter
		  faraday.authorization @authentication.first, @authentication.last if @authentication
		end
	end
end

class DiscogsClient
	def initialize
		@json_client = JSONClient.new 'https://api.discogs.com'
		@json_client.authenticate(:Discogs, "key=jOUDsbzZVnrDNJmDPIeF, secret=HLlLvludcKgpaSfFyHAhkvTQyWlIWiHN") # You need a 'secret' here!
	end

	def search(phrase)
		json = @json_client.get '/database/search', {q: phrase}

		results = json["results"]
		release = results.find { |e| e["type"] == "release" && e["format"].include?("CD") && e["format"].include?("Album") }
		release
	end

	def find_album(album_url)
		@json_client.get(album_url)
	end
end

client = DiscogsClient.new

release = client.search "overkill ironbound"

url = release["resource_url"]

album = client.find_album(url)

puts "Tytuł: #{album["title"]}"
puts "Artysta: #{album["artists"].first["name"]}"
puts "Gatunek: #{album["genres"].join(", ")}"
puts "Styl: #{album["styles"].join(". ")}"
puts "Lista utworów:"
album["tracklist"].each do |track|
	puts "#{track["position"]}\t[#{track["duration"]}]\t#{track["title"]}"
end
