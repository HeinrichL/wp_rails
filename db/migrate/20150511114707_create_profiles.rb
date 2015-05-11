class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :firstname
      t.string :surname
      t.date :birthday
      t.text :description

      t.timestamps
    end
  end
end
