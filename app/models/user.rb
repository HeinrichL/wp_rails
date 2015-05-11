class User < ActiveRecord::Base
  has_one :profile, autosave: true  
  attr_accessible :email, :password
end
