class TrackYourTracksAdapter
	@@base_uri = 'https://trackyourtracks.mybluemix.net'
	@@api_token = '6ce672532a0d420b85bdcdcb731c9794'
	
	def initialize
		@api_token = get_api_token
	end
	
	def get_api_token
	#https://trackyourtracks.mybluemix.net/api/tyt/comm/erzeugeToken/Frontend1/passwort
	end
	
	def self.create(track)
		options = {:body => track.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
		result = HTTParty.post(@@base_uri+'/api/tyt/track/create/'+@@api_token, options)
		self.hash_to_route(result.parsed_response)
	end
	
	def self.search(criteria)
		options = {:body => criteria.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
		result = HTTParty.post(@@base_uri+'/api/tyt/track/findWithStartingPoint/'+@@api_token, options)
		if result.response.instance_of?(Net::HTTPBadRequest)
			[]
		elsif result.response.instance_of?(Net::HTTPOK)
			result.parsed_response.map do |x|
				self.hash_to_route(x)
			end
		end
	end
	
	def self.hash_to_route(x)
		route = Route.new()
		route.id = x["id_strecke"]
		route.name = x["label"]
		route.address = x["streckenpunkte"]
		route
	end
end