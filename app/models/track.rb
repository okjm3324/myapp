class Track < ApplicationRecord
  belongs_to :user
  belongs_to :song
  has_many :comments,  dependent: :destroy
  has_many :like, dependent: :destroy

  enum section: { intro: 0, verse: 1, bridge: 2, chorus: 3, solo: 4, ending:5}
  enum instrument: { guitar: 0, bass: 1, drums: 2, keyboard: 3, sax: 4 }

  def liked_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
