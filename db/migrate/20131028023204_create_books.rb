class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :content
      t.string :name
      t.integer :user_id

      t.timestamps
    end
      add_index :books, [:user_id, :created_at]
  end
end
