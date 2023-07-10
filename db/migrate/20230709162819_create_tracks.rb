class CreateTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :tracks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true
      t.integer :start
      t.integer :end
      t.integer :section
      t.integer :bpm
      t.integer :instrument

      t.timestamps
    end
  end
end
