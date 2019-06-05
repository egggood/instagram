class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :active_likes, class_name: "Like", foreign_key: "user_id", dependent: :destroy
  has_many :liking, through: :active_likes, source: :micropost
  mount_uploader :profile_picture, PictureUploader
  attr_accessor :remember_token
  validates :name, presence: true, length: { maximum: 50 }
  validates :user_name, presence: true, length: { maximum: 50 }, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # self.email.empty?だとundifined method for NilClassになった。nil,empty,blankの違いを知らい
  before_save { self.email = self.email.downcase unless self.email.nil? }
  validates :email, presence: true, allow_blank: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  # 正規表現でphonenumberを帰省したがその書き方が分からないので後回し
  validates :phonenumber, presence: true, allow_blank: true, uniqueness: true
  # genderはmaleとfemaleだけしかpassしないようにする
  validates :gender, presence: true, allow_blank: true
  validates :self_introduction, presence: true, allow_blank: true, length: { maximum: 140 }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # 投稿にいいねする
  def like(micropost)
    liking << micropost
  end

  # 投稿のいいねを取り消す
  def undo_like(micropost)
    active_likes.find_by(micropost_id: micropost.id).destroy
  end

  # いいねした東欧ならtureを返す
  def like?(micropost)
    liking.include?(micropost)
  end
end
