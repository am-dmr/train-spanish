class CreateWords < ActiveRecord::Migration[6.0]
  def change
    create_table :words do |t|
      t.string :spanish, null: false
      t.string :russian, null: false
      t.string :articles, array: true, null: false, default: []
      t.integer :part_of_speech, null: false

      t.timestamps
    end
  end
end
