class RemoveIndexAppointment < ActiveRecord::Migration
  def change
  	remove_index :appointments, [:routes_id, :groups_id]
  end
end
