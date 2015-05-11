class GroupmembersRenamed < ActiveRecord::Migration
  def change
	if Groupmember.table_exists? 
	 drop_table :groupmembers
	end
	
	create_table :groups_users, id: false do |f| 
		f.belongs_to :users, index: true
		f.belongs_to :groups, index: true 
	end
  end
end
