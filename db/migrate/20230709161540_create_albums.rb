class CreateAlbums < ActiveRecord::Migration[7.0]
  def change
    create_table :albums do |t|
      t.string :title
      t.integer :genre
      t.string :artist_name

      t.timestamps
    end
  end
end
