class CreateCriteria < ActiveRecord::Migration[5.0]
  def change
    create_table :criteria do |t|
      t.integer :story_id
      t.string :content
    end
  end
end
