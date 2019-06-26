require 'rails_helper'
require 'support/login_support'

RSpec.feature "Sessions#new", type: :feature do
  context "ログインしていない時" do
    scenario "login_pathにredirectする" do
      visit new_micropost_path
    end
  end

  context "ログインしている時" do
    let!(:user) { create(:user) }

    before do
      sign_in user
    end

    # 写真の投稿をテストできてない
    scenario "投稿に成功する" do
      visit user_path user.id
      click_link '投稿'
      expect(page).to have_current_path new_micropost_path

      fill_in "micropost_content", with: "こんにちは"
      click_button 'Post'

      expect(page).to have_current_path user_path user.id
      expect(page).to have_content '投稿に成功しました'
    end

    scenario "投稿に失敗する" do

      visit user_path user.id
      click_link '投稿'
      expect(page).to have_current_path new_micropost_path

      fill_in "micropost_content", with: nil
      click_button 'Post'

      expect(page).to have_current_path microposts_path
      expect(page).to have_content "Content can't be blank"
    end
  end
end
