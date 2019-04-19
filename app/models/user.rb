class User < ApplicationRecord
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
  validates :password, presence: true, length:{minimum: 6}
end
