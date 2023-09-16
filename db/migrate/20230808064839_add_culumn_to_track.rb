class AddCulumnToTrack < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :original_bpm, :integer, null: false
    add_column :tracks, :duration, :integer, null: false
  end
end
