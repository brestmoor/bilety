class AddAccountToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :account, foreign_key: true
  end
end
