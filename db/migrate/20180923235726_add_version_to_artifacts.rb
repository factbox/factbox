class AddVersionToArtifacts < ActiveRecord::Migration[5.0]
  def change
    add_column :artifacts, :version, :string, default: "snapshot"
  end
end
