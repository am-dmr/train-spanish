class CreateTrainings < ActiveRecord::Migration[6.0]
  def change
    create_table :trainings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :word, null: false, foreign_key: true
      t.integer :result, null: false, default: 0

      t.timestamps
    end
  end
end
