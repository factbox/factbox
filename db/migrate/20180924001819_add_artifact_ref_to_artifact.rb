class AddArtifactRefToArtifact < ActiveRecord::Migration[5.0]
  def change
    add_column :artifacts, :artifact_id, :integer
  end
end
