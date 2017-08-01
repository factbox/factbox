class ChangeArtifactsFieldsToBeRequired < ActiveRecord::Migration[5.0]
  def change
    change_column :artifacts, :title, :string, null: false
    change_column :artifacts, :actable_type, :string, null: false
  end
end
