require 'test_helper'

class TrackYourTracksAdapterTest < ActiveSupport::TestCase
	test "label already exists" do
		routes = [{:street => "Berliner Tor", :number => '103a', :zip => '22005', :city => 'Hamburg', :country => 'DE'}, {:street => "Berliner Tor", :number => '7', :zip => '22005', :city => 'Hamburg', :country => 'DE'}]
		track = {:name => "TestStrecke2", :address => routes}
		assert_raises(TrackYourTracksAdapter::LabelAlreadyExistsError) { TrackYourTracksAdapter.create(track) }
	end
	
	test "get_new_api_token_cause_current_token_expired" do
		TrackYourTracksAdapter.api_token = 'a'
		criteria = {:street => "Berliner Tor", :number => '103a', :zip => '22005', :city => 'Hamburg', :country => 'DE'}
		result = TrackYourTracksAdapter.search(criteria)
	end
	
	test "create track" do 
		routes = [{:street => "Berliner Tor", :number => '103a', :zip => '22005', :city => 'Hamburg', :country => 'DE'}, {:street => "Berliner Tor", :number => '7', :zip => '22005', :city => 'Hamburg', :country => 'DE'}]
		track = {:name => "TestStrecke3", :address => routes}
		result = TrackYourTracksAdapter.create(track)
		Rails.logger.debug(result)
		TrackYourTracksAdapter.delete(result.id)
	end
	
	test "try to create track with unknown address" do
		routes = [{:street => "Gaga", :number => '10300a', :zip => '22005', :city => 'Hamburg', :country => 'DE'}, {:street => "Unknown street", :number => '7000', :zip => '22005', :city => 'Hamburg', :country => 'DE'}]
		track = {:name => "Gaga", :address => routes}
		assert_raises(TrackYourTracksAdapter::UnknownLocationError){ result = TrackYourTracksAdapter.create(track)}
		Rails.logger.debug(result)
		if result.is_a?("Route")
			TrackYourTracksAdapter.delete(result.id)
		end
	end
	
	test "search for unknown track" do
		criteria = {:street => "Unknown street", :number => '10000', :zip => '22005', :city => 'Hamburg', :country => 'DE'}
		assert []==TrackYourTracksAdapter.search(criteria)
	end
	
	test "search track" do
		criteria = {:street => "Berliner Tor", :number => '103a', :zip => '22005', :city => 'Hamburg', :country => 'DE'}
		result = TrackYourTracksAdapter.search(criteria)
		result.each do |x| 
			x.is_a?(Route)
		end
	end
	
	test "service not available" do
	end
	
	test "find track" do
	
	end
end
