class Reply < ApplicationRecord
  belongs_to :micropost
  validates :content, presence: true, length: {maximum: 140}
end
