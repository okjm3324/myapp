class AddColumnToSongs < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :song_code, :string, null: false
    add_index :songs, :song_code, unique: true
  end
end
