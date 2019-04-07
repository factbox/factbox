class AddProjectNameToBeUnique < ActiveRecord::Migration[5.2]
  def change
    change_column :projects, :name, :string, unique: true
  end
end
