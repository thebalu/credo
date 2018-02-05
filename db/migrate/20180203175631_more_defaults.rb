class MoreDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column :schedules, :queue, :integer, default: 0
  end
end
