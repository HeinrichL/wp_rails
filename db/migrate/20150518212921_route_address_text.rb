class RouteAddressText < ActiveRecord::Migration
  def change
    remove_column :routes, :address
	add_column :routes, :address, :text
  end
end
