class Micropost < ApplicationRecord
  belongs_to :user
  has_many :reply
  has_many :passive_likes, class_name: "Like", foreign_key: "micropost_id", dependent: :destroy
  has_many :liked, through: :passive_likes, source: :user
  mount_uploader :picture, PictureUploader
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  validate :picture_size

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
