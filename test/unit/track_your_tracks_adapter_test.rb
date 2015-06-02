require 'test_helper'

class TrackYourTracksAdapterTest < ActiveSupport::TestCase

	AUTHOR_NAME = 'bicycleonrails'
	@@base_uri = 'https://trackyourtracks.mybluemix.net'
	@@api_token = '6ce672532a0d420b85bdcdcb731c9794'
	test "unsafed connection" do
		hhash = {:strasse => "Berliner Tor"}
		options = {:body => hhash.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
		result = HTTParty.post('http://trackyourtracks.mybluemix.net/api/tyt/track/findWithStartingPoint/'+@@api_token, options)
	end
	
	test "unauthorized 401" do
	
	end
	
	test "bad request 400" do
	
	end
	
	test "forbidden 403" do
	
	end
	
	test "not found 404" do
	
	end
	
	test "get_api_token" do

	end
	
	test "get_new_api_token_cause_current_token_expired" do
		options = {:headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
		result = HTTParty.post(@@base_uri+'/api/tyt/track/delete/'+@@api_token+'/'+result.id.to_s, options)
	end
	
	test "create_track" do 
		routes = [{:strasse => "Berliner Tor", :hausnummer => '103a', :plz => '22005', :ort => 'Hamburg', :Land => 'DE', :letzteEntfernung => 0}, {:strasse => "Berliner Tor", :hausnummer => '7', :plz => '22005', :ort => 'Hamburg', :Land => 'DE', :letzteEntfernung => 120}]
		track = {:label => "TestStrecke2", :autorName => AUTHOR_NAME, :tags => ["WALD"], :streckenpunkte => routes}
		result = TrackYourTracksAdapter.create(track)
		Rails.logger.debug(result)
		options = {:headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
		result = HTTParty.post(@@base_uri+'/api/tyt/track/delete/'+@@api_token+'/'+result.id.to_s, options)
	end
	
	test "search for unknown track" do
		criteria = {:strasse => "Unknown street", :hausnummer => '10000', :plz => '22005', :ort => 'Hamburg', :Land => 'DE'}
		assert []==TrackYourTracksAdapter.search(criteria)
	end
	
	test "search track" do
		criteria = {:strasse => "Berliner Tor", :hausnummer => '103a', :plz => '22005', :ort => 'Hamburg', :Land => 'DE'}
		result = TrackYourTracksAdapter.search(criteria)
		result.each do |x| 
			x.is_a?(Route)
		end
	end
end
