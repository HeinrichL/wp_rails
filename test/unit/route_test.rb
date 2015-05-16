require 'test_helper'

class RouteTest < ActiveSupport::TestCase
  test "register" do 
    @route = Route.new
	Route.post('/backend/rest/signup/', {:username => 'bicycleonrails', :emailaddress => 'noreply@bicycleonrails.eu-gb.mybluemix.net', :password => '1234'})
  end
  
  test "parse json to route object" do
    jsonRoute = "{\"name\": \"Um die Alster\", 
	\"address\": [
		{\"geopoint\": [12,12]},
		{\"geopoint\": [13,13]}
	]}"
	result = JSON.parse(jsonRoute)
    @route = Route.new
	@route.parse(result)
    assert @route.name=="Um die Alster"
	expectedAddress = JSON.parse("[
		{\"geopoint\": [12,12]},
		{\"geopoint\": [13,13]}
	]")
	
	assert @route.address==expectedAddress
  end
  
  test "search with mockup" do
    puts Route.search('alster')
  end
end
