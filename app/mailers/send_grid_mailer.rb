class SendGridMailer < ActionMailer::Base
  default from: "noreply@bicycleonrails.eu-gb.mybluemix.net"
  
  def joined_group(recipient, user, group)
    @user = user
	@recipient = recipient
	@group = group
    @url  = 'http://bicycleonrails.eu-gb.mybluemix.net'
	@recipient.each do |x|
      mail(to: x.email, subject: @user.profile.firstname+' joined your group').deliver
	end
  end  
  
  def left_group(recipient, user, group)
    @user = user
	@recipient = recipient
	@group = group
    @url  = 'http://bicycleonrails.eu-gb.mybluemix.net'
	@recipient.each do |x|
      mail(to: x.email, subject: @user.profile.firstname+' left your group').deliver
	end
  end  

  def post_created(recipients, user, group_id, message)  
    @url  = 'http://bicycleonrails.eu-gb.mybluemix.net'
	@group_id = group_id
	@user = user
	@message = message
    recipients.each do |x|
	  if(x.id != user.id)
	    mail(to: x.email, subject: @user.profile.firstname+ ' posted in your group').deliver
	  end
	end
  end
end
