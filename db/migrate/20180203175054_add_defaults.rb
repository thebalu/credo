class AddDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column :schedules, :queue, :integer, default: :unseen
    change_column :schedules, :ef, :decimal, default: 2.5
    change_column :schedules, :lapsed, :boolean, default: false
    change_column :schedules, :reps, :integer, default: 0
    change_column :schedules, :interval, :integer, default: 0

  end
end
