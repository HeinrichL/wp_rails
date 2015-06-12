class UsersController < ApplicationController
  # GET /users/login
  def login

  end
  
  # GET /users/logout
  def logout
	session.delete(:user_id)
	redirect_to root_url
  end
  
  # POST /users/authenticate
  def authenticate
	if temp = User.where(email: params[:email], password: params[:password]).first
      session[:user_id] = temp.id
	  flash[:success] = "Login erfolgreich"
	  if session[:location].nil?
		redirect_to root_url
	  else
		redirect_to session[:location]
	  end
	else
	  flash.now[:alert] = "Falsche E-Mail or falsches Passwort"
	  render 'login'
    end
  end
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
	
	@free = true;
	@premium = false;
	
	if params[:mode] == "premium"
		@premium = true
	end
	
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @user.create_profile(params[:profile])
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  # GET /users/search?q=SEARCH_CRTIERA
  def search
   @results = Profile.where('firstname LIKE ? or surname LIKE ? or description LIKE ?', "%#{request.GET['q']}%", "%#{request.GET['q']}%", "%#{request.GET['q']}%")
  end 
end
