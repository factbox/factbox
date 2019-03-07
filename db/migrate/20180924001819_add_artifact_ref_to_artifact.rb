class AddArtifactRefToArtifact < ActiveRecord::Migration[5.0]
  def change
    add_column :artifacts, :origin_id, :integer
  end
end
