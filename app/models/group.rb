class Group < ActiveRecord::Base
  has_and_belongs_to_many :users, :foreign_key => 'groups_id', :association_foreign_key => 'users_id' 
  attr_accessible :description, :name
end
