class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.boolean :status, default: false
      t.belongs_to :user, index: true, null: false
      t.integer :answer_id
      t.timestamps
    end
  end
end
