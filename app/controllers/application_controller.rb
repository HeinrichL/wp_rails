class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :delete_session_path
  
  def delete_session_path
	unless params[:controller]=="users" and (params[:action]=="login" or params[:action]=="authenticate")
	 session.delete(:location)
	end
  end
  
  def user_logged_in?
     unless not session[:user_id].nil?
      session[:location] = request.original_url
      redirect_to({controller: "users", action: "login"}, notice: "Please sign in.")
	 end
  end
end
