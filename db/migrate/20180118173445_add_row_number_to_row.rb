class AddRowNumberToRow < ActiveRecord::Migration[5.1]
  def change
    add_column :rows, :row_number, :string
  end
end
