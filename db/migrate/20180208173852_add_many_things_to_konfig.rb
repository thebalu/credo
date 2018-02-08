class AddManyThingsToKonfig < ActiveRecord::Migration[5.0]
  def change
    add_column :konfigs, :day_cutoff, :integer
    add_column :konfigs, :reps, :integer, default: 0
    add_column :konfigs, :unseen_count, :integer, default: 0
    add_column :konfigs, :learn_count, :integer,default: 0
    add_column :konfigs, :review_count, :integer,default: 0
    add_column :konfigs, :unseen_modulus, :integer,default: 0
  end
end
