class ChangeVersionColumnToArtifact < ActiveRecord::Migration[5.2]
  def change
    change_column_null :artifacts, :version, false
    change_column_default :artifacts, :version, nil
  end
end
