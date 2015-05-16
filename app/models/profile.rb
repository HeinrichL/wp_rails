class Profile < ActiveRecord::Base
	belongs_to :user
  attr_accessible :birthday, :description, :firstname, :surname
  validates :firstname, presence: true
end
