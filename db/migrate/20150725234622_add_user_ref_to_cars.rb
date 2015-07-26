class AddUserRefToCars < ActiveRecord::Migration
  def change
    add_reference :cars, :user, index: true
    add_foreign_key :cars, :users
  end
end
