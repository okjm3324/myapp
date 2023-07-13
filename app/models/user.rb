class User < ApplicationRecord

  authenticates_with_sorcery!
  has_many :tracks, dependent: :destroy

  validates :name, presence: true, uniqueness: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password, presence: true, confirmation: true, length: {minimum: 6}, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  enum role: { general: 0, admin: 1 }
  enum instrument: { guitar: 0, bass: 1, drums: 2, keyboard: 3, sax: 4 }
end
