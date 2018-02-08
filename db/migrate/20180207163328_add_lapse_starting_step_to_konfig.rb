class AddLapseStartingStepToKonfig < ActiveRecord::Migration[5.0]
  def change
    add_column :konfigs, :lapse_starting_step, :integer
  end
end
