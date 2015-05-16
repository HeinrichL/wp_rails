class PostsController < ApplicationController
  include PostsHelper
  # POST /posts/create
  def create
   create_and_send_mail(params[:post][:message], params[:post][:group_id])
   redirect_to({:controller => "groups", :action => "show", :id => params[:post][:group_id]})
  end
end
