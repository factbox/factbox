class CreateSources < ActiveRecord::Migration[5.2]
  def change
    change_table :artifacts do |t|
      t.references :source, index: true
    end
  end
end
