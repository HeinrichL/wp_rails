class TrackYourTracksAdapter
	class LabelAlreadyExistsError < RuntimeError
	end
	class UnknownLocationError < RuntimeError
	end
	@@base_uri = 'https://trackyourtracks.mybluemix.net'
	cattr_writer :api_token
	@@api_token = 'a'
	AUTHOR_NAME = 'bicycleonrails'
	PASSWORD = 'test'
	
	def self.create(track)
		track_ = {}
		track_[:autorName] = AUTHOR_NAME
		track_[:tags] = []
		track_[:laenge] = "0"
		track_[:label] = track[:name]
		track_[:streckenpunkte] = track[:address].map do |x| 
			x[:strasse] = x[:street]
			x[:hausnummer] = x[:number]
			x[:plz] = x[:zip]
			x[:ort] = x[:city]
			x[:Land] = x[:country]
			x
		end
		Rails.logger.debug(track_)
		options = {:body => track_.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}}

		result = HTTParty.post(@@base_uri+'/api/tyt/track/create/'+@@api_token, options)
		
		if result.response.instance_of?(Net::HTTPUnauthorized)
			Rails.logger.debug('token expired2')
			self.get_token()
			self.create(track)		
		elsif result.response.instance_of?(Net::HTTPOK)
			route = self.hash_to_route(result.parsed_response)
			route.save!
			route
		else
			begin 
				Rails.logger.debug(result)
				
			rescue MultiJson::LoadError => e
				Rails.logger.debug(e.message)
				if e.message == "795: unexpected token at 'Label ist schon vergeben.'"
					raise LabelAlreadyExistsError
				elsif e.message == "795: unexpected token at 'Geokoordinaten konnten nicht ermittelt werden.'"
					raise UnknownLocationError
				end
			end
			raise StandardError
		end
	end
	
	def self.get_token
		options = {}
		result = HTTParty.get(@@base_uri+"/api/tyt/comm/erzeugetoken/#{AUTHOR_NAME}/#{PASSWORD}", options)
		hash = result.parsed_response
		@@api_token = hash["apiToken"]
	end
	
	def self.search(h)
		criteria = {:strasse => h[:street], :hausnummer => h[:number], :plz => h[:zip], :ort => h[:city], :Land => h[:country]}
		Rails.logger.debug(criteria)
		options = {:body => criteria.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
		result = HTTParty.post(@@base_uri+'/api/tyt/track/findWithStartingPoint/'+@@api_token, options)
		if result.response.instance_of?(Net::HTTPBadRequest)
			[]
		elsif result.response.instance_of?(Net::HTTPUnauthorized)
			Rails.logger.debug('token expired')
			self.get_token()
			self.search(h)
		elsif result.response.instance_of?(Net::HTTPOK)
			result.parsed_response.map do |x|
				self.hash_to_route(x)
			end
		else
			raise StandardError			
		end
	end
	
	def self.getRouteById(id)
		options = {}
		result = HTTParty.get(@@base_uri+'/api/tyt/track/findByNr/'+@@api_token+'/'+id, options)
		if result.response.instance_of?(Net::HTTPUnauthorized)
			Rails.logger.debug('token expired  routebyid')
			self.get_token()
			self.getRouteById(id)
		elsif result.response.instance_of?(Net::HTTPOK)
			self.hash_to_route(result)
		elsif result.response.instance_of?(Net::HTTPBadRequest)
			raise RuntimeError, "Couldn't find Route with id #{id}"
		else
			raise StandardError
		end
	end
	
	def self.hash_to_route(x) 
		route = Route.new()
		route.id = x["id_strecke"]
		route.name = x["label"]
		route.address = x["streckenpunkte"]
		route
	end
	
	def self.delete(id)
		options = {:headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
		HTTParty.post(@@base_uri+'/api/tyt/track/delete/'+@@api_token+'/'+id.to_s, options)
	end
end