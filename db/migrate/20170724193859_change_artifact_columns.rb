class ChangeArtifactColumns < ActiveRecord::Migration[5.0]
  def change
    change_column :artifacts, :project_id, :integer, null: false
    change_column :artifacts, :author_id, :integer, null: false
  end
end
