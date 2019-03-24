class ChangeDefaultValueOfLastVersion < ActiveRecord::Migration[5.2]
  def change
    change_column_default :artifacts, :last_version, true
  end
end
