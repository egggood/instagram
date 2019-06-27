require 'rails_helper'
require 'support/login_support'

RSpec.feature "Microposts#show", type: :feature do
  context "ログインしていない時" do
    let(:micropost) { create(:micropost) }

    scenario "login_pathにredirectする" do
      visit micropost_path micropost.id
      expect(page).to have_current_path login_path
    end
  end

  context "ログインしている時" do
    let(:user) { create(:user) }
    let(:micropost) { create(:micropost, user: user) }

    before do
      sign_in user
    end

    context "いいねしてない投稿" do
      # 写真の投稿をテストできてない
      scenario "必要な情報が表示される" do
        visit micropost_path micropost.id
        expect(page).to have_current_path micropost_path micropost.id
        expect(page).to have_content micropost.content
        expect(page).to have_button "いいね！"
        expect(page).to have_button "返信する"
      end
    end

    context "いいねしてる投稿" do
      before do
        user.liking << [micropost]
      end

      scenario "必要な情報が表示される" do
        visit micropost_path micropost.id
        expect(page).to have_current_path micropost_path micropost.id
        expect(page).to have_content micropost.content
        expect(page).to have_button "いいねを取り消す"
        expect(page).to have_button "返信する"
      end
    end
  end
end
