class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.decimal :balance, precision: 8, scale: 2

      t.timestamps
    end
  end
end
