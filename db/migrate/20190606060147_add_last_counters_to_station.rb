class AddLastCountersToStation < ActiveRecord::Migration[5.2]
  def change
    add_column :stations, :latest_used_bikes, :integer
    add_column :stations, :latest_free_bikes, :integer
  end
end
