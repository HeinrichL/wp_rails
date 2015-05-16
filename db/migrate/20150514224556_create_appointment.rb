class CreateAppointment < ActiveRecord::Migration
  def change
	create_table :appointments, id: false do |f|
		f.belongs_to :routes, index: true
		f.belongs_to :groups, index: true 
	end
	
	add_index :appointments, [:routes_id, :groups_id], unique: true
  end
end
