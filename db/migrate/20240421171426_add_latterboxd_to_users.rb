class AddLatterboxdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :letterboxd, :string
  end
end
