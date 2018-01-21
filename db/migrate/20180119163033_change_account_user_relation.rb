class ChangeAccountUserRelation < ActiveRecord::Migration[5.1]
  def change
    remove_reference :users, :account, foreign_key: true
    add_reference :accounts, :user, foreign_key: true
  end
end
