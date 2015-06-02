require 'httparty'
require 'uri'

class Route < ActiveRecord::Base
  has_many :appointments, :foreign_key => 'routes_id'
  has_many :groups, through: :appointments
  attr_accessible :name, :address
  @base_uri = 'http://trackyourtracks.mybluemix.net'
  @app_username = 'bicycleonrails'
  @app_password = 'test'
  

  def self.login
    options = {}
    result = HTTParty.get(@base_uri+"/api/tyt/user/login/#{@app_username}/#{@app_password}", options)
  end
  
  public
  def self.search(search_criteria)
  logger.debug(search_criteria)
    options = {:body => search_criteria.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
    result = HTTParty.post(@base_uri+'/api/tyt/track/findWithStartingPoint', options) 

	result.map do |x|
	    result = Route.convert_backend_result x
		@route = Route.new 
		@route.id = result["id"]
		@route.name = result["name"]
		@route.address = result["address"].to_s
		@route
	end
  end
  
  def self.getRouteByIdAndSave(id)
    options = {}
    result = HTTParty.get(@base_uri+'/api/tyt/track/findByNr/'+id, options) 
	logger.debug result.parsed_response
	result = Route.convert_backend_result(result.parsed_response)
    @route = Route.new 
	@route.id = result["id"]
	@route.name = result["name"]
	@route.address = result["address"].to_s
	@route.save!
	@route	
  end
  
  def self.validateAddress(address)
    result = HTTParty.get(@base_uri+'/backend/rest/address/'+URI.escape(address))
    result = JSON.parse(result)
	result[0]
  end
  
  def self.create(hash)
    if hash.is_a?(Hash)
	Route.login
    response = HTTParty.post(@base_uri+'/api/tyt/track/create', :body => hash.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}) 
	result = response.parsed_response

	result = Route.convert_backend_result(result)

    @route = Route.new 
	@route.id = result["id"]
	@route.name = result["name"]
	@route.address = result["address"].to_s
	@route.save!
	@route
	else
		raise ArgumentError, "Only hash is accepted as argument"
	end
  end
  
  def self.convert_backend_result(result)
	result["id"] = result.delete("id_strecke")
	result["address"] = result.delete "streckenpunkte"
	result["name"] = result.delete "label"  
	result
  end
end
