class Track < ApplicationRecord
  belongs_to :user
  belongs_to :song
  has_many :comments,  dependent: :destroy
  has_many :like, dependent: :destroy
  validate :start_must_be_less_than_end
  validates :original_bpm, presence: true
  validates :duration, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :section, presence: true
  validates :bpm, presence: true
  validates :instrument, presence: true

  enum section: { intro: 0, verse: 1, bridge: 2, chorus: 3, solo: 4, ending:5}
  enum instrument: { guitar: 0, bass: 1, drums: 2, keyboard: 3, sax: 4 }

  def liked_by?(user)
    like.exists?(user_id: user.id)
  end

  private

  def start_must_be_less_than_end
    if start_time.present? && end_time.present? && start_time >= end_time
      errors.add(:start_time, "must be less than end position")
    end
  end
end
