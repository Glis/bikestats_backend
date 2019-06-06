class CreateUsageLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :usage_logs do |t|
      t.references :station, foreign_key: true
      t.integer :used_bikes
      t.integer :free_bikes

      t.timestamps
    end
  end
end
