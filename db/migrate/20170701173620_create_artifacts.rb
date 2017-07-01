class CreateArtifacts < ActiveRecord::Migration[5.0]
  def change
    create_table :artifacts do |t|
      t.integer :author_id
      t.integer :project_id
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
