class AddLastVersionToArtifacts < ActiveRecord::Migration[5.2]
  def change
    add_column :artifacts, :last_version, :boolean
  end
end
