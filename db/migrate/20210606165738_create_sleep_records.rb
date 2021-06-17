class CreateSleepRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :sleep_records do |t|
      t.belongs_to :user, foreign_key: true
      t.date :night, null: false, index: { unique: true }
      t.float :went_to_bed, :woke_up, :time_in_bed, :movements_per_hour, :snore_time, null: false
      t.integer :sleep_quality, null: false

      t.timestamps
    end
  end
end
