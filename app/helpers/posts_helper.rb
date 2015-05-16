module PostsHelper
	def create_and_send_mail(message, group_id)
		@post = Post.new({:message => message, :group_id => group_id, :user_id => session[:user_id]}, :without_protection => true)
		@post.save!
		@user = User.find(session[:user_id])
		SendGridMailer.post_created(@post.group.users, @user, group_id, message)
	end
end
