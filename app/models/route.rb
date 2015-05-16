require 'httparty'
require 'uri'

class Route < ActiveRecord::Base
  has_many :appointments, :foreign_key => 'routes_id'
  has_many :groups, through: :appointments
  attr_accessor :name, :address
  @base_uri = 'http://localhost:3000'
  # attr_accessible :title, :body
  @app_username = ''
  @app_password = ''
  
  private
  def login
    options = {:username => @app_username, :password  => @app_password}
    HTTParty.post(@base_uri+'/backend/rest/login/', options)
  end
  
  public
  def self.search(search_criteria)
    options = {:filterStr => search_criteria}
    result = HTTParty.post(@base_uri+'/backend/rest/routes/', options) 

	result = JSON.parse(result)
	result.map do |x|
	  Route.new.parse x
	end
  end
  
  def parse(json)
	if json.is_a?(Hash)
		json.each do |key, value| 
		  self.send("#{key}=", value)
		end
	else
	  raise ArgumentError, "Only hash is accepted as argument"
	end
	
	self
  end
  
  def name
    if @name.nil?
		result = Route.getRouteById(id)
		parse(JSON.parse(result)[0])
	else
	  @name
	end
  end
  
  def self.getRouteById(id)
    options = {:id => id}
    result = HTTParty.post(@base_uri+'/backend/rest/routes/', options) 
  end
  
  def self.validateAddress(address)
    result = HTTParty.get(@base_uri+'/backend/rest/address/'+URI.escape(address))
    result = JSON.parse(result)
	result[0]
  end
  
  def self.create(hash)
    if hash.is_a?(Hash)
    options = {:route => JSON.generate(hash)}
    result = HTTParty.post(@base_uri+'/backend/rest/addRoute/', options) 
    @route = Route.new.parse(JSON.parse(result))
	@route.save!
	@route
	else
		raise ArgumentError, "Only hash is accepted as argument"
	end
  end
end
