class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  attr_accessible :message
end
