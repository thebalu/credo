class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.integer :card_id
      t.integer :student_id
      t.integer :due
      t.integer :queue
      t.boolean :lapsed
      t.integer :learning_step
      t.integer :reps
      t.integer :interval

      t.timestamps
    end
  end
end
