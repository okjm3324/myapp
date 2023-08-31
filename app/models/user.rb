class User < ApplicationRecord

  authenticates_with_sorcery!

  has_one_attached :avatar
  has_many :tracks, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true, uniqueness: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password, presence: true, confirmation: true, length: {minimum: 6}, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :access_token, presence: true
  validates :refresh_access_token, presence: true


  enum role: { general: 0, admin: 1 }
  enum instrument: { guitar: 0, bass: 1, drums: 2, keyboard: 3, sax: 4 }

  def self.find_or_create_from_omniauth!(auth_hash)
    user = User.find_or_initialize_by!(provider: auth_hash[:provider], uid: auth_hash[:uid])
    user.update!(
      name: auth_hash[:info][:name],
      avatar: auth_hash[:info][:image],
      access_token: auth_hash[:credentials][:token],
      refresh_token: auth_hash[:credentials][:refresh_token]
    )
    user
  end

  def follow(other_user)
    following << other_user unless self == other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  
end
