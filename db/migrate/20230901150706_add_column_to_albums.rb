class AddColumnToAlbums < ActiveRecord::Migration[7.0]
  def change 
    add_column :albums, :album_image, :string
  end
end
