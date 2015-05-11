class User < ActiveRecord::Base
  has_one :profile, autosave: true
  has_and_belongs_to_many :groups
  attr_accessible :email, :password
end
