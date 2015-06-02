require 'test_helper'

class RouteHelperTest < ActionView::TestCase
  include RoutesHelper
  test "string to address" do
    result = string_to_address("Berliner Tor 3a, 22005 Hamburg, DE")
	assert result[:strasse]=="Berliner Tor"
	assert result[:hausnummer]=="3a"
	assert result[:plz]=="22005"
	assert result[:ort]=="Hamburg"
	assert result[:land]=="DE"
  end
  
   test "string to address2" do
    result = string_to_address("Berliner Tor 3a 22005 Hamburg DE")
	assert result[:strasse]=="Berliner Tor"
	assert result[:hausnummer]=="3a"
	assert result[:plz]=="22005"
	assert result[:ort]=="Hamburg"
	assert result[:land]=="DE"
  end 
end
