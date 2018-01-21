class AddAdultsOnlyToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :adults_only, :boolean, default: false
  end
end
