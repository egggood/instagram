require 'rails_helper'

RSpec.describe User, type: :model do
  #有効なファクトロリを持つ
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  #nameがnilなら無効な状態であること
  it "is invalid without a name" do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  #nameの長さは50より大きくなってはいけない(50はok)
  #英語の文法合ってる？
  it "is invalid with name that's length is than 50" do
    user = FactoryBot.build(:user, name: "a"*51)
    user.valid?
    expect(user.errors[:name]).to include("is too long (maximum is 50 characters)")
 end

 #user_nameがnilなら無効な状態であること
  it "is invalid without a user_name" do
    user = FactoryBot.build(:user, user_name: nil)
    user.valid?
    expect(user.errors[:user_name]).to include("can't be blank")
  end

  #user_nameの長さは50より大きくなってはいけない(50はok)
  it "is invalid with user_name that's length is than 50" do
    user = FactoryBot.build(:user, user_name: "a"*51)
    user.valid?
    expect(user.errors[:user_name]).to include("is too long (maximum is 50 characters)")
  end

  #emailがnilでも有効であること
  #expect(FactoryBot.build(:user, email: "")).to be_validだと可読性が下がる？
  #be_validだとbefore_saveが実行されない?nilだとself.email.downcaseのdowncaseが実行できなくて手動で確認するとエラーになった、
  #before_save{self.email = self.email.downcase unless self.email.nil?}で対処はしといたが問題だよね...
  it "is valid without an email" do
    user = FactoryBot.build(:user, email: "")
    expect(user).to be_valid
  end

  #phonenumberがnilでも有効であること
  it "is valid without a phonenumber" do
    user = FactoryBot.build(:user, phonenumber: "")
    expect(user).to be_valid
  end

  #gendetがnilでも有効であること
  it "is valid without a phonenumber" do
    user = FactoryBot.build(:user, gender: "")
    expect(user).to be_valid
  end

  #user_nameはuniqueでなければならない
  #user.errors[:email]に"has alredy been taken"がはいっていればいいので、
  #emailとphonenumberをFactoryBot.create(:user)のオブイェクトから変える必要はない？
  #必要はないがどっちがオススメなのか
  it "is invalid with a duplicate user_name address" do
    user = FactoryBot.create(:user)
    other_user = FactoryBot.build(:user)
    other_user.user_name = user.user_name
    other_user.valid?
    expect(other_user.errors[:user_name]).to include("has already been taken")
  end

  #phonenumberはuniqueでなければならない
  it "is invalid with a duplicate phonenumber" do
    user = FactoryBot.create(:user)
    other_user = FactoryBot.build(:user)
    other_user.phonenumber = user.phonenumber
    other_user.valid?
    expect(other_user.errors[:phonenumber]).to include("has already been taken")
  end

  #emailrはuniqueでなければならない
  it "is invalid with a duplicate email address" do
    user = FactoryBot.create(:user)
    other_user = FactoryBot.build(:user)
    other_user.email = user.email
    other_user.valid?
    expect(other_user.errors[:email]).to include("has already been taken")
  end

  #emailは大文字も小文字としてみなさなければならない
  it "is invalid with a user.email.upcase when user.email.douncase has already been saved" do
    user = FactoryBot.build(:user)
    user.email = user.email.downcase
    user.save
    other_user = FactoryBot.build(:user)
    other_user.email = user.email.upcase
    other_user.valid?
    expect(other_user.errors[:email]).to include("has already been taken")
  end

  #emailが規定の型を満たない時はvalid?=>falseになるべき
  it "is invalid with a invalid email" do
    invalid_email = %W[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_email.each do |invalid_address|
      #inspectてきなやつはないのかな？
      user = FactoryBot.build(:user, email: invalid_address)
      user.valid?
      expect(user.errors[:email]).to  include("is invalid")
    end
  end

  #有効なemailをもつuserはvalid?=>trueになるべき
  #正規表現に合わないemailが一つでもあると、その最小のやつがvalidatin
  #に引っかかって後のemailは検証されなかった。
  it "is valid with a valid email" do
    valid_email = %W[user@example.com USER@foo.com A_USER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_email.each do |valid_address|
      #inspectてきなやつはないのかな？
      user = FactoryBot.build(:user, email: valid_address)
      expect(user).to be_valid
    end
  end

  #passwordはがnilなら無効な状態であること
  it "is invalid without a password" do
    user = FactoryBot.build(:user)
    user.password = user.password_confirmation = " "
    user.valid?
    #bcryptで具体的に何が起こっているのか詳細を理解していないuser.errorsのどのシンボルを持って来ればいいか迷った。
    expect(user.errors[:password]).to include("can't be blank")
  end

  #passwordは最低でも6以上の文字数でなければいけない
  it "is invalid with less than 5 characterster password" do
    user = FactoryBot.build(:user, password: "a"*5, password_confirmation: "a"*5)
    user.valid?
    expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
  end

  #self_introductionは140を超えてはいけない（以内はOK)
  it "is invalid with a than 140 characters self_introduction" do
    user = FactoryBot.build(:user, self_introduction: "a"*141)
    user.valid?
    expect(user.errors[:self_introduction]).to include("is too long (maximum is 140 characters)")
  end






end
