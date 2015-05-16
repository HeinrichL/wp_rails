class Appointment < ActiveRecord::Base
   belongs_to :route, :foreign_key => 'routes_id'
   belongs_to :group, :foreign_key => 'groups_id'
   attr_accessible :routes_id, :groups_id, :date
end
