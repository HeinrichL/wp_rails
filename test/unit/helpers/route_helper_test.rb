require 'test_helper'

class RouteHelperTest < ActionView::TestCase
  include RoutesHelper
  test "string to address" do
    result = string_to_address("Berliner Tor 3a, 22005 Hamburg, DE")
	assert result[:address]=="Berliner Tor"
	assert result[:no]=="3a"
	assert result[:zip]=="22005"
	assert result[:city]=="Hamburg"
	assert result[:country]=="DE"
  end
  
   test "string to address" do
    result = string_to_address("Berliner Tor 3a 22005 Hamburg DE")
	assert result[:address]=="Berliner Tor"
	assert result[:no]=="3a"
	assert result[:zip]=="22005"
	assert result[:city]=="Hamburg"
	assert result[:country]=="DE"
  end 
end
