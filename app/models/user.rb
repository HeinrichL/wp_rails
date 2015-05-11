class User < ActiveRecord::Base
  has_one :profile, autosave: true
  has_and_belongs_to_many :groups, :foreign_key => 'users_id', :association_foreign_key => 'groups_id' 
  attr_accessible :email, :password
  validates :email, uniqueness: true, on: :create
end
