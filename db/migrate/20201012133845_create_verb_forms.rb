class CreateVerbForms < ActiveRecord::Migration[6.0]
  def change
    create_table :verb_forms do |t|
      t.references :word, null: false, foreign_key: true
      t.integer :tense, null: false
      t.integer :pronoun, null: false
      t.string :spanish, null: false

      t.timestamps
    end
  end
end
