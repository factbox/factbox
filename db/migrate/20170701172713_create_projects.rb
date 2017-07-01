class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.integer :author_id
      t.integer :metodology_id
      t.boolean :is_public

      t.timestamps
    end
  end
end
