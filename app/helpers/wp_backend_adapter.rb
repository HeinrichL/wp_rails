require 'uri'

class WPBackendAdapter
  class LabelAlreadyExistsError < RuntimeError
  end
  class InvalidAddressError < RuntimeError
  end
  class UnknownLocationError < RuntimeError
  end
  class UnauthorizedError < RuntimeError
  end
  class UnhandledError < RuntimeError
  end

  @@base_uri = 'http://wp-backend.mybluemix.net/backend/'
  @@backend_rest_uri = @@base_uri + 'rest/'
  @@backend_auth_uri = @@base_uri + 'oauth/'

  @@username = 'bicycleonrails'
  @@password = 'geheim'
  @@UserId = 5

  ## Auth-Token
  # holt sich ein aktuelles Auth-Token bom Backend
  def self.get_token
    options = {}
    result = HTTParty.get(@@backend_auth_uri + 'token?grant_type=password&client_id=restapp&client_secret=restapp&username='+@@username+'&password='+@@password,options)
    result['access_token']
  end

  ## /routes/addRoute
  # fuegt dem Backend eine neue Route hinzu
  def self.create(track)
    track_ = {}
    track_[:bezeichnung] = track[:name].to_s

    track_[:start] = track[:address][0]
    track_[:ende] = track[:address][track[:address].length - 1]

    track_[:zwischenpunkte] = []
    if track[:address].length > 2
      track[:address][1..track[:address].length - 2].each do |x|
        track_[:zwischenpunkte] << x
      end
    end
    track_[:pois] = [{:bezeichnung => '', :info => '', :adresse => 'berliner tor 7 20099 hamburg'}]
    track_[:laenge] = "0"

    options = {:body => {:route => track_.to_json}, :headers => { 'Content-Type' => 'application/x-www-form-urlencoded', 'Accept' => 'application/json'}}
    result = HTTParty.post(@@backend_rest_uri+'routes/addRoute' + '?access_token=' + get_token, options)
    handleResult(result) {|route| route.each {|x| addRouteToBoR(x['id'],x['bezeichnung'])}}
  end

  ## /address/{address}
  # validiert address
  def self.validate_address(address)
    options = {}
    result = HTTParty.get(@@backend_rest_uri+'address/'+ URI.escape(address) + '?access_token=' + get_token, options)
    result['status'] == '200' and result['size'] > 0
  end

  def self.getUserId()
    options = {}
    result = HTTParty.get(@@backend_rest_uri+'user/'+ @@username + '?access_token=' + get_token, options)
    begin
      res = handleResult(result) { |x| x[0]['id']}
    rescue
      signup()
      result = HTTParty.get(@@backend_rest_uri+'user/'+ @@username + '?access_token=' + get_token, options)
      res = result['responseValue'][0]['id']
    end
    res
  end

  def self.signup
    post = {:username => @@username,
            :password => 'test',
            :forename => 'bicycleonrails',
            :surname => 'bicycleonrails',
            :emailAddress => 'bicycleonrailsathawhamburgde',
            :street => 'BerlinerTor',
            :housenumber => '7',
            :plz => '20099',
            :city => 'Hamburg',
            :country => 'Germany'}
    options = {:body =>
                   post,
                :headers => { 'Content-Type' => 'application/x-www-form-urlencoded', 'Accept' => 'application/json'}}
    HTTParty.post(@@backend_rest_uri+'user/newUser?access_token=' + get_token, options)
  end

  ## /routes/getRoute
  # gibt Route nach ID zurueck
  def self.getRouteByID(id)
    options = {:body => {:id => id}, :headers => { 'Content-Type' => 'application/x-www-form-urlencoded', 'Accept' => 'application/json'}}
    result = HTTParty.post(@@backend_rest_uri+'/routes/getRoute?access_token=' + get_token, options)
    handleResult(result) {|x| hash_to_route(x[0])}
  end

  ## /user/getRoutes
  # gibt alle Routen für user zurueck
  def self.getRoutesByUser(user)
    options = {}
    result = HTTParty.get(@@backend_rest_uri+'user/getRoutes/'+ URI.escape(user) + '?access_token=' + get_token, options)
    handleResult(result) {|routes| routes.map { |x| hash_to_route(x)}}
  end

  ## /routes
  # sucht Routen nach Suchkriterium
  def self.searchRoute(criteria)
    options = {:body => {:filterStr => criteria.to_s}, :headers => { 'Content-Type' => 'application/x-www-form-urlencoded', 'Accept' => 'application/json'}}
    result = HTTParty.post(@@backend_rest_uri+'routes' + '?access_token=' + get_token, options)
    #result
    self.handleResult(result) { |routes| routes.map {|x| hash_to_route(x)}}
  end

  ## /user/addFav
  # verknüpft Route mit Applikationsaccount
  def self.addRouteToBoR(idRoute, routename)
    options = {:body => {iduser: @@UserId,
                         username: @@username,
                         idroute: idRoute,
                         routename: routename},
               :headers => { 'Content-Type' => 'application/x-www-form-urlencoded'}}
    result = HTTParty.post(@@backend_rest_uri+'user/addFav' + '?access_token=' + get_token, options)
    handleResult(result) {|bool| bool[0]}
  end

  ## /user/delFav
  # entfernt Route vom Applikationsaccount
  def self.deleteRouteFromBoR(idRoute, routename)
    options = {:body => {iduser: @@UserId,
                         username: @@username,
                         idroute: idRoute,
                         routename: routename},
               :headers => { 'Content-Type' => 'application/x-www-form-urlencoded'}}
    result = HTTParty.post(@@backend_rest_uri+'user/delFav' + '?access_token=' + get_token, options)
    #handleResult(result) {|bool| bool[0]}
  end

  ##
  # mappt die Backend-Route auf einheitliches Format
  def self.hash_to_route(x)
    route = Route.new()
    route.id = x['id'].to_s
    route.name = x['bezeichnung'].to_s
    route.address = []
    route.address << x['start']
    x['zwischenpunkte'].each { |x| route.address << x }
    route.address << x['ende']
    route
  end

  ##
  # behandelt den HTTP-Result
  # wenn Status 403, dann unautorisiert
  # wenn Status 400, dann keine Daten
  # wenn Status 200 und mind. 1 Result in Array, dann wende Block auf result an
  def self.handleResult(result)
    if result['status'] == '200' and result['size'] > 0
      yield(result['responseValue'])
    elsif result['status'] == '403'
      raise UnauthorizedError
    elsif result['status'] == '400' and result['size'] == 0
      "no data available"
    else
      raise UnhandledError
    end
  end
end