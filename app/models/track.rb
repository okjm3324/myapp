class Track < ApplicationRecord
  belongs_to :user
  belongs_to :song

  enum section: { intro: 0, verse: 1, Bridge: 2, Chorus: 3, Solo: 4, Ending:5}
  enum instrument: { guitar: 0, bass: 1, drums: 2, keyboard: 3, sax: 4 }
end
