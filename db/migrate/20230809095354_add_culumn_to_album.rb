class AddCulumnToAlbum < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :album_code, :string, null: false
    add_index :albums, :album_code, unique: true
  end
end
