class CreateSleepFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :sleep_files do |t|
      t.belongs_to :user, foreign_key: true
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
