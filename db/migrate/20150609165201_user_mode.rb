class UserMode < ActiveRecord::Migration
  def change
	add_column :users, :mode, :integer, default: 0
  end
end
