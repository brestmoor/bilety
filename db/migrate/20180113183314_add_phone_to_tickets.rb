class AddPhoneToTickets < ActiveRecord::Migration[5.1]
  def change
    add_column :tickets, :phone, :string
  end
end
