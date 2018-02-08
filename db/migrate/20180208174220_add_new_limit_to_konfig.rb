class AddNewLimitToKonfig < ActiveRecord::Migration[5.0]
  def change
    add_column :konfigs, :new_limit, :integer, default: 20
  end
end
