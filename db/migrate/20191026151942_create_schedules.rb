class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.references :movie, foreign_key: true
      t.date :date

      t.timestamps
    end
  end
end
