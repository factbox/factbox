class ChangeAuthorToBeRequiredInProject < ActiveRecord::Migration[5.0]
  def change
    change_column :projects, :author_id, :integer, null: false
    change_column :projects, :is_public, :boolean, default: true
  end
end
