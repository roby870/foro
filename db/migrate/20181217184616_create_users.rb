class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_hash, null: false
      t.string :screen_name, null: false
      t.string :email, null: false
      t.string :token
      t.datetime :token_created_at
      t.timestamps
    end
    add_index :users, :username
  end
end
