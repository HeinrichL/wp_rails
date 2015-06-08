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

  @@username = 'test'
  @@password = 'geheim'
  @@UserId = 444

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
    #return track.to_s
    track_[:bezeichnung] = track[:name]

    track_[:start] = track[:address][0]
    track_[:ende] = track[:address][track[:address].length - 1]

    track_[:zwischenpunkte] = []
    if track[:address].length > 2
      track[:address][1..track[:address].length - 2].each do |x|
        track_[:zwischenpunkte] << x
      end
    end
    track_[:pois] = []
    track_[:laenge] = "0"

    #track_.to_s

    options = {:body => track_.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
    result = HTTParty.post(@@backend_rest_uri+'routes/addRoute' + '?access_token=' + get_token, options)
    #addRouteToBoR(result['id'],result['bezeichnung'])
    #self.hash_to_route(result.parsed_response)
    result
  end

  ## /address/{address}
  # validiert address
  def self.validate_address(address)
    options = {}
    result = HTTParty.get(@@backend_rest_uri+'address/'+ URI.escape(address) + '?access_token=' + get_token, options)
    if result['status'] == '200' and result['size'] > 0
      true
    else
      false
    end
  end

  def self.signup
    post = {:username => 'bicycleonrails',
            :Forename => 'bicycleonrails',
            :Surname => 'bicycleonrails',
            :Emailaddress => 'bicycleonrails@haw-hamburg.de',
            :Password => 'test',
            :Street => 'Berliner Tor',
            :Nr => '7',
            :Plz => '20099',
            :City => 'Hamburg',
            :Country => 'Germany'}
    options = {:body =>
                   post.to_json,
                :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
    result = HTTParty.post(@@backend_rest_uri+'user/newUser?access_token=' + get_token, options)
    #handleResult(result)
    #post.to_json
  end

  ## /user/getRoutes
  # gibt alle Routen für user zurueck
  def self.getRoutesByUser(user)
    options = {}
    result = HTTParty.get(@@backend_rest_uri+'user/getRoutes/'+ URI.escape(user) + '?access_token=' + get_token, options)
    #if result['status'] == '200' and result['size'] > 0
    self.handleResult(result) {result.map {|x| hash_to_route(x)}}
      #result.map {|x| self.hash_to_route(x)}
    #elsif result['status'] == '403'
    #  raise UnauthorizedError
    #elsif result['status'] == '400' and result['size'] == 0
    #  []
    #else
    #  raise UnhandledError
    #end
  end

  ## /routes
  # sucht Routen nach Suchkriterium
  def self.searchRoute(criteria)
    options = {:body => {:filterStr => criteria.to_s}, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
    result = HTTParty.post(@@backend_rest_uri+'routes' + '?access_token=' + get_token, options)
    self.handleResult(result) {result.map {|x| hash_to_route(x)}}
    #if result['status'] == '200' and result['size'] > 0
    #  result
    #elsif result['status'] == '403'
    #  raise UnauthorizedError
    #elsif result['size'] == 0
    #  "no routes found"
    #else
    #  raise UnhandledError
    #end

  end

  ## /user/addFav
  # verknüpft Route mit Applikationsaccount
  def self.addRouteToBoR(idRoute, routename)
    options = {:body => {:idUser => @@UserId, :username => @@username, :idRoute => idRoute, :routename => routename}.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}}
    result = HTTParty.post(@@backend_rest_uri+'user/addFav' + '?access_token=' + get_token, options)
    result
  end

  def self.hash_to_route(x)
    route = Route.new()
    route.id = x["id"]
    route.name = x["bezeichnung"]
    route.address = x["start"] ++ x["zwischenpunkte"] ++ x["ziel"]
    route
  end

  def self.handleResult(result)
    if result['status'] == '200' and result['size'] > 0
      yield(result)
    elsif result['status'] == '403'
      raise UnauthorizedError
    elsif result['status'] == '400' and result['size'] == 0
      "no routes found"
    else
      raise UnhandledError result.to_s
    end
  end
end