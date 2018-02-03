class CreateDecks < ActiveRecord::Migration[5.0]
  def change
    create_table :decks do |t|
      t.string :name
      t.text :description
      t.integer :klass_id

      t.timestamps
    end
  end
end
