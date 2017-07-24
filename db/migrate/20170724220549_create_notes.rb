class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.string :content
    end
    change_table :artifacts do |t|
      t.integer :actable_id
      t.string  :actable_type
    end
  end
end
