class CreateBooking < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.string :identification
      t.string :name
      t.string :email
      t.string :phone
      t.references :schedule, foreign_key: true

      t.timestamps
    end
  end
end
