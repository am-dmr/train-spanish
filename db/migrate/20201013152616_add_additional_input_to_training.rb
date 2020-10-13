class AddAdditionalInputToTraining < ActiveRecord::Migration[6.0]
  def change
    add_column :trainings, :additional_input, :jsonb
  end
end
