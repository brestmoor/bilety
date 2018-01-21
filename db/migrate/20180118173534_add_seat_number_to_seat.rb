class AddSeatNumberToSeat < ActiveRecord::Migration[5.1]
  def change
    add_column :seats, :seat_number, :integer
  end
end
