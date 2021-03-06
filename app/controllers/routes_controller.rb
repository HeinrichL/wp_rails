class RoutesController < ApplicationController  
  include PostsHelper
  # GET /routes/search
  def search
   if not params[:q].nil?
     result = Route.search(params[:q])
	 logger.debug(result)
	 @results = result[:result]
	 @service = result[:service]
		 render partial: "livesearch", layout: false
   end
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
	begin
		@route = Route.create({:name => params[:name], :address => params[:address].compact})
		if not params[:group_id].nil? and not params[:group_id].empty?
		  @group = Group.find(params[:group_id])
		  date = Date.new params[:appointment]["date(1i)"].to_i, params[:appointment]["date(2i)"].to_i, params[:appointment]["date(3i)"].to_i
		  add_routes_to_group(@route, @group, date)
		end
		redirect_to({ :controller => "routes", :action => "show", :id => @route.id}, notice: 'Route was successfully created.')		
	rescue TrackYourTracksAdapter::LabelAlreadyExistsError => e
		@route = Route.new
		@route.errors.add(:name, 'Name already exists')
		new()
		render 'new'
	rescue StandardError => s
		logger.debug (s)
		@route = Route.new
		@route.errors.add(:form, 'Unknown error occured')
		new()
		render 'new'
	end
  end
  
  # GET /routes/show/:id
  def show
    @route = Route.where(id: params[:id]).first
	if @route.nil? 
	  @route = Route.getRouteByIdAndSave params[:id], params[:service]
	end
	
	@route[:address] = JSON.parse(@route[:address])
	@route_id = params[:id]
	@groups = [['Add to group (optional)', nil]]
	User.find(session[:user_id]).groups.each do |g|
		@groups << [g.name, g.id]
	end
  end
  
  # POST /routes/add
  def add_group
    date = Date.new params[:appointment]["date(1i)"].to_i, params[:appointment]["date(2i)"].to_i, params[:appointment]["date(3i)"].to_i
	@route = Route.find_or_create_by_id(params[:route_id])
	
	@group = Group.find(params[:group_id])
    add_routes_to_group(@route, @group, date)
	redirect_to({:controller => 'groups', :action => 'show', :id => params[:group_id]}, notice: 'Route was successfully added.') 
  end
  
  def add_routes_to_group(route, group, date)
	   route.appointments.create(:route => route, :groups_id => group.id, :date => date).save!
	   create_and_send_mail('has created an appointment '+view_context.link_to(route.name, {:controller=>"routes", :action=>"show", :id => route.id})+' for '+date.to_s+' in group ', group.id)
	#end
  end
end
