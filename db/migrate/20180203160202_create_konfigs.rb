class CreateKonfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :konfigs do |t|
      t.integer :deck_id
      t.integer :student_id
      t.string :grad_steps
      t.integer :starting_step

      t.timestamps
    end
  end
end
