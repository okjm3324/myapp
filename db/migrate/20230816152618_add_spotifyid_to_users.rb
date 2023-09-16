class AddSpotifyidToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :user_code, :string, null: false
    add_index :users, :user_code, unique: true
  end
end
