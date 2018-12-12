class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_hash
      t.string :screen_name
      t.string :email
      t.string :token
      t.datetime :token_created_at
      t.timestamps
    end
    add_index :users, :username
  end
end
