class AddWorkToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :work, :string
    add_column :users, :location, :string
  end
end
