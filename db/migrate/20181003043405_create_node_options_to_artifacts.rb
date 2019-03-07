class CreateNodeOptionsToArtifacts < ActiveRecord::Migration[5.2]
  def change
    create_table :node_options do |t|
      t.belongs_to :artifact, index: true
      t.string :bg_color
      t.string :hover_bg_color
      t.string :icon_face
      t.string :image_selected
      t.string :image_unselected
      t.string :title
    end
  end
end
