class UpdateStoryAddLayer < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :layer, :integer, default: 0
  end
end
