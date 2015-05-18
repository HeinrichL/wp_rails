class ExtendRoute < ActiveRecord::Migration
  def change
    add_column :routes, :address, :string
	add_column :routes, :name, :string
  end
end
