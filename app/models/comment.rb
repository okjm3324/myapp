class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :track

  validates :content, presence: true
end
