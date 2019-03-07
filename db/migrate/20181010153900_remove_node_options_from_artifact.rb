class RemoveNodeOptionsFromArtifact < ActiveRecord::Migration[5.2]
  def change
    drop_table :node_options
  end
end
