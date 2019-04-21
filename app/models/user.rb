class User < ApplicationRecord
  attr_accessor :remember_token
  validates :name, presence: true, length:{maximum: 50}
  validates :user_name, presence: true, length:{maximum: 50}, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #self.email.empty?だとundifined method for NilClassになった。nil,empty,blankの違いを知らい
  before_save {self.email = self.email.downcase unless self.email.nil?}
  validates :email, presence: true, allow_blank: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  #正規表現でphonenumberを帰省したがその書き方が分からないので後回し
  validates :phonenumber, presence: true, allow_blank: true, uniqueness: true
  #genderはmaleとfemaleだけしかpassしないようにする
  validates :gender, presence: true, allow_blank: true
  has_secure_password
  validates :password, presence: true, length:{minimum: 6}, allow_nil: true
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
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
end
