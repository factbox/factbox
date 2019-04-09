class ChangeAuthorToBeNulableInProject < ActiveRecord::Migration[5.2]
  def change
    change_column_null :projects, :author_id, true
  end
end
