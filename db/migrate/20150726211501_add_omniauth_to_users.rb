class AddOmniauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :omniauth, :boolean, default: false
  end
end
