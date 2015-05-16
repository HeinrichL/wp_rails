class Group < ActiveRecord::Base
  has_and_belongs_to_many :users, :foreign_key => 'groups_id', :association_foreign_key => 'users_id' 
  has_many :appointments, :foreign_key => 'groups_id'
  has_many :routes, through: :appointments
  has_many :posts
  attr_accessible :description, :name
end
