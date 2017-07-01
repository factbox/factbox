class CreateUrutaUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :uruta_users do |t|
      t.string :email
      t.string :name
      t.string :lastName
      t.string :login
      t.string :password_digest

      t.timestamps
    end
  end
end
