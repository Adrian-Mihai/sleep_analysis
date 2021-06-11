class CreateSleepRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :sleep_records do |t|
      t.belongs_to :user, foreign_key: true
      t.datetime :went_to_bed, null: false
      t.datetime :woke_up, null: false
      t.integer :quality, null: false
      t.integer :snore, null: false
      t.integer :time_in_bed, null: false
      t.integer :movements_in_bed, null: false

      t.timestamps
    end

    add_index :sleep_records, :went_to_bed
    add_index :sleep_records, :woke_up
  end
end
