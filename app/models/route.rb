require 'httparty'
require 'uri'

class Route < ActiveRecord::Base
  has_many :appointments, :foreign_key => 'routes_id'
  has_many :groups, through: :appointments
  attr_accessible :name, :address
  TYT = 'TrackYourTracksAdapter'
  WPB = ''

  ##
  # returns Service, [Route]
  #
  def self.search(search_criteria)
    criteria = self.validateAddress(search_criteria)
	Rails.logger.debug(criteria)
	{:service => :TrackYourTracksAdapter, :result => TrackYourTracksAdapter.search(criteria)}

  end
  
  def self.getRouteByIdAndSave(id, service)
	if service == TYT
		route = TrackYourTracksAdapter.getRouteById(id)
		route.save!
		route
	elsif service == WPB
	
	else
		raise RuntimeError, "Unknown service"
	end
  end
  
  ##
  # pre: address.string
  # post: {street, number, zip, city, country}
  def self.validateAddress(address)
	if address.empty? 
		return nil
	end
	
	address
	# if service is not available use RoutesHelper::string_to_address
	ApplicationController.helpers.string_to_address(address)
  end
  
  def self.create(hash)
	address = []
	hash[:address].each do |x|
		result = self.validateAddress(x)
		if not result.nil?
			address << result
		end
	end
	
	hash[:address] = address
	Rails.logger.debug('bla')
	Rails.logger.debug(hash)
	
	begin
		TrackYourTracksAdapter.create(hash)
		#wp backend
	rescue
		
	end

  end
end
