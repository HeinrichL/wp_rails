require 'test_helper'

class RoutesControllerTest < ActionController::TestCase
  BLA = "Blalbla, 00001 Blabla, BB"
  BERLINER_TOR_3 = "Berliner Tor 3a, 22005 Hamburg, DE"
  BERLINER_TOR_103 = "Berliner Tor 103a, 22005 Hamburg, DE"
  
  test "should get search" do
    get :search
    assert_response :success
  end
  
  test "create track successfully" do
	post :create, {:name => random_string, :address => [BERLINER_TOR_3, BERLINER_TOR_103]}
	assert_redirected_to({ :controller => "routes", :action => "show", :id => @route.id})  
  end
  
  test "create track with existing label" do
	post :create, {:name => "TestStrecke2", :address => [BERLINER_TOR_3, BERLINER_TOR_103]}
  end
  
  test "create track with any non existant geo data" do
	post :create, {:name => random_string, :address => [BLA, BERLINER_TOR_103]}
  end 
  
  test "search track" do
	get :search, :q => BERLINER_TOR_3
    assert_response :success
	Rails.logger.debug(@results)
  end
  
  test "search track with any data" do
	get :search, :q => BLA
    assert_response :success
	Rails.logger.debug(@results)
  end
  
  def random_string
	(0...50).map { ('a'..'z').to_a[rand(26)] }.join
  end
end
