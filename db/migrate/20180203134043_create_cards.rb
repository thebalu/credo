class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.text :front
      t.text :back
      t.integer :deck_id

      t.timestamps
    end
  end
end
