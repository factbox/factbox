class CreateStories < ActiveRecord::Migration[5.0]
  def change
    create_table :layers do |t|
      t.integer :project_id
      t.string  :name
    end

    create_table :stories do |t|
      t.integer :layer_id
      t.string  :story
    end
  end
end
