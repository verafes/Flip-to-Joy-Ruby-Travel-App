class AddRoleToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :role, null: false, foreign_key: true
  end
end
