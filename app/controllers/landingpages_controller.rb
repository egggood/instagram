class LandingpagesController < ApplicationController
  def home
    #後ほどuserがフォローしているユーザーの画像だけを表示する仕様にする
    @microposts = Micropost.all
  end

  def about
  end

  def contact
  end

  def help
  end

  def terms_of_use
  end
end
