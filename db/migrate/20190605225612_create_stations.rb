class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|
      t.string :identifier
      t.string :name
      t.datetime :last_updated
      t.integer :total_bikes

      t.timestamps
    end
  end
end
