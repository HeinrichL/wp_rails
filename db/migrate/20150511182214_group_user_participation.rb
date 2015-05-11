class GroupUserParticipation < ActiveRecord::Migration
  def change
	create_table :groupmembers, id: false do |f|
		f.belongs_to :users, index: true
		f.belongs_to :groups, index: true 
	end
  end
end
