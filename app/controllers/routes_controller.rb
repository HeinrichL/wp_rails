class RoutesController < ApplicationController  
  include PostsHelper
  # GET /routes/search
  def search
   @results = Route.search(params[:q])
  end
  
  # GET /routes/new
  def new
    @groups = [['Add to group (optional)', nil]]
	User.find(session[:user_id]).groups.each do |g|
		@groups << [g.name, g.id]
	end
  end
  
  # POST /routes
  def create
    address = params[:address]
	address = address.split(',').map do |a| 
		Route.validateAddress(a)
	end
	@route = Route.create({"name" => params[:name], "address" => address})

	if not params[:group_id]==""
	  @group = Group.find(params[:group_id])
	  date = Date.new params[:appointment]["date(1i)"].to_i, params[:appointment]["date(2i)"].to_i, params[:appointment]["date(3i)"].to_i
	  add_routes_to_group(@route, @group, date)
	end
	redirect_to({ :controller => "routes", :action => "show", :id => @route.id}, notice: 'Route was successfully created.')
  end
  
  # GET /routes/show/:id
  def show
    result = Route.getRouteById(params[:id])
	@route = Route.new.parse(JSON.parse(result))
	@route_id = params[:id]
	@groups = [['Add to group (optional)', nil]]
	User.find(session[:user_id]).groups.each do |g|
		@groups << [g.name, g.id]
	end
  end
  
  # POST /routes/add
  def add_group
    date = Date.new params[:appointment]["date(1i)"].to_i, params[:appointment]["date(2i)"].to_i, params[:appointment]["date(3i)"].to_i
    add_routes_to_group(params[:route_id], params[:group_id], date)
	redirect_to({:controller => 'groups', :action => 'show', :id => params[:group_id]}, notice: 'Route was successfully added.') 
  end
  
  def add_routes_to_group(route, group, date)
  #group.update_attributes(:routes => route)
  logger.debug 'group_id'+group.id.to_s
	   route.appointments.create(:route => route, :groups_id => group.id, :date => date).save!
	   create_and_send_mail('has created an appointment '+view_context.link_to(route.name, {:controller=>"routes", :action=>"show", :id => route.id})+' for '+date.to_s+' in group ', group.id)
	#end
  end
end
