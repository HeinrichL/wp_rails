class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :message
      t.references :user
      t.references :group

      t.timestamps
    end
    add_index :posts, :user_id
    add_index :posts, :group_id
  end
end
