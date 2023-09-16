class ChangeColumnNameInTracks < ActiveRecord::Migration[7.0]
  def change
    rename_column :tracks, :end, :end_time
    rename_column :tracks, :start, :start_time
  end
end
