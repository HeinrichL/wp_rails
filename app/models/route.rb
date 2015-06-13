require 'httparty'
require 'uri'

class Route < ActiveRecord::Base
  has_many :appointments, :foreign_key => 'routes_id'
  has_many :groups, through: :appointments
  attr_accessible :name, :address
  TYT = 'TrackYourTracksAdapter'
  WPB = 'WPBackendAdapter'

  ##
  # returns Service, [Route]
  #
  def self.search(search_criteria)
    criteria = self.validateAddress(search_criteria)
		Rails.logger.debug(criteria)
		tytSearch = TrackYourTracksAdapter.search(criteria)
		if tytSearch == []
			{:service => :WPBackendAdapter, :result => WPBackendAdapter.searchRoute(criteria)}
		else
			{:service => :TrackYourTracksAdapter, :result => tytSearch}
		end
  end
  
  def self.getRouteByIdAndSave(id, service)
		if service == TYT
			route = TrackYourTracksAdapter.getRouteById(id)
			route.save!
			route
		elsif service == WPB
			route = WPBackendAdapter.getRouteById(id)
			route.save!
			route
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

		tytRoute = TrackYourTracksAdapter.create(hash)
		#wp backend
		WPBackendAdapter.create(hash)
		tytRoute.save!
		tytRoute
  end
end
