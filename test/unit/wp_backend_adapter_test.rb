require 'test_helper'

class WPBackendAdapterTest < ActiveSupport::TestCase

  test "invalid address" do
    assert_equal(WPBackendAdapter.validate_address("unknown address"), false)
  end

  test "validate address" do
    assert_equal(WPBackendAdapter.validate_address("Berliner Tor 7"), true)
  end

  test "userid" do
    #WPBackendAdapter.getUserId
    assert_equal(WPBackendAdapter.getUserId(), 5)
  end

  #test "create" do
  #  WPBackendAdapter.create({:name => 'RailsRoute1', :address => ["Berliner tor 7 20099 hamburg","Berliner tor 30 20099 hamburg","Hamburger Strasse 1"]})
  #end

  test "getroute" do
    route = WPBackendAdapter.getRouteByID(1)
    assert_equal(1, route.id)
    assert_equal('RailsRoute1', route.name)
  end

  test "getroutes by user" do
    routes = WPBackendAdapter.getRoutesByUser('bicycleonrails')
    assert_equal(1, routes.length)
  end

  test "hash to route" do
    start = {
        :id => 3,
        :longitude => 10.06191,
        :latitude => 53.66257,
        :street => "Stofferkamp",
        :housenumber => "75",
        :plz => "22399",
        :city => "Hamburg",
        :country => "Germany",
        :addressType => [:STREET_ADDRESS]}
    ende = {
        :id => 2,
        :longitude => 9.99153,
        :latitude => 53.55351,
        :street => "Jungfernstieg",
        :housenumber => "22",
        :plz => "20354",
        :city => "Hamburg",
        :country => "Germany",
        :addressType => [:STREET_ADDRESS]}
    zwischenpunkt = {
        :id => 6,
        :longitude => 10.05974,
        :latitude => 53.609848,
        :street => "Cesar-Klein-Ring",
        :housenumber => "28",
        :plz => "22309",
        :city => "Hamburg",
        :country => "Germany",
        :addressType => [:STREET_ADDRESS]}
    backendRoute = {
        'id' => 1,
        'bezeichnung' => "Horny Route 66",
        'start' => start,
        'ende' => ende,
        'zwischenpunkte' => [zwischenpunkt],
        'pois' => [],
        'laenge' => 25900}
    mappedRoute = WPBackendAdapter.hash_to_route(backendRoute)
    assert_equal(1, mappedRoute.id)
    assert_equal("Horny Route 66", mappedRoute.name)
    assert_equal([start,zwischenpunkt,ende], mappedRoute.address)
  end
end