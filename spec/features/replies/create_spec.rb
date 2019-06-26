require 'rails_helper'
require 'support/login_support'

RSpec.feature "Sessions#new", type: :feature do
  let(:micropost) { create(:micropost) }

  context "ログインしていない時" do
    scenario "login_pathにリダイレクトする" do
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

    scenario "コメントに成功する" do
      visit micropost_path micropost.id
      expect(page).to have_current_path micropost_path micropost.id
      expect(page).to have_content micropost.content

      fill_in "reply_content", with: "replayしたよ"
      click_button "返信する"
      expect(page).to have_current_path micropost_path micropost.id
      expect(page).to have_content "投稿に成功しました。"
      expect(page).to have_content "replayしたよ"
    end

    scenario "コメントに失敗する" do
      visit micropost_path micropost.id
      expect(page).to have_current_path micropost_path micropost.id
      expect(page).to have_content micropost.content

      fill_in "reply_content", with: nil
      click_button "返信する"
      expect(page).to have_current_path reply_index_path
      expect(page).to have_content "投稿に失敗しました"
    end
  end
end
