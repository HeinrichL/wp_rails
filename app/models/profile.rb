class Profile < ActiveRecord::Base
	belongs_to :user
  attr_accessible :birthday, :description, :firstname, :surname
end
