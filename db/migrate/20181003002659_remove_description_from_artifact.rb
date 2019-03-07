class RemoveDescriptionFromArtifact < ActiveRecord::Migration[5.2]
  def change
    remove_column :artifacts, :description, :string
  end
end
