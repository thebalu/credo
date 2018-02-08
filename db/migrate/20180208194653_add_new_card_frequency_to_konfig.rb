class AddNewCardFrequencyToKonfig < ActiveRecord::Migration[5.0]
  def change
    add_column :konfigs, :new_card_frequency, :integer
  end
end
