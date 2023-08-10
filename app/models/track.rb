class Track < ApplicationRecord
  belongs_to :user
  belongs_to :song

  enum section: { intro: 0, verse: 1, bridge: 2, chorus: 3, solo: 4, ending:5}
  enum instrument: { guitar: 0, bass: 1, drums: 2, keyboard: 3, sax: 4 }
end
