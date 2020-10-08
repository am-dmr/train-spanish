class AddUserInputToTrainings < ActiveRecord::Migration[6.0]
  def change
    add_column :trainings, :user_input, :string, null: false, default: ''
  end
end
