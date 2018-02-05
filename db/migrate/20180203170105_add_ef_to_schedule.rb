class AddEfToSchedule < ActiveRecord::Migration[5.0]
  def change
    add_column :schedules, :ef, :decimal
  end
end
