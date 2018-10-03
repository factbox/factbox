class CreateImageArtifact < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.actable
    end
  end
end
