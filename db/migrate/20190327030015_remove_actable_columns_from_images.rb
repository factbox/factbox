class RemoveActableColumnsFromImages < ActiveRecord::Migration[5.2]
  def change
    remove_column :images, :actable_type
    remove_column :images, :actable_id
  end
end
