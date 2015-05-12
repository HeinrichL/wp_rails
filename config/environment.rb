ActionMailer::Base.smtp_settings = {
  :user_name => 'apOeJhQq2o',
  :password => '7Xxtii5x0n',
  :domain => 'bicycleonrails.eu-gb.mybluemix.net',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
RailsStarter::Application.initialize!
