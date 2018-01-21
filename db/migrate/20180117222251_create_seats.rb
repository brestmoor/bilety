class CreateSeats < ActiveRecord::Migration[5.1]
  def change
    create_table :seats do |t|
      t.references :row, foreign_key: true
      t.boolean :occupied

      t.timestamps
    end
  end
end
