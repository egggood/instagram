require 'rails_helper'
require 'support/login_support'

RSpec.feature "Users#edit", type: :feature do
  context "ログインしていない時" do
    let(:user) { create(:user) }

    scenario "ログイン画面にリダイレクトする" do
      visit user_path user.id
      expect(page).to have_current_path login_path
    end
  end

  context "ログインしている時" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      sign_in user
    end

    context "他人の情報を見ている時" do
      scenario "編集ボタンが存在しない" do
        visit user_path other_user.id
        expect(page).to have_current_path user_path other_user.id
        expect(page).not_to have_content "編集"
      end

      scenario "follow/unfollowボタンがある" do
        visit user_path other_user.id
        expect(page).to have_current_path user_path other_user.id
        expect(page).to have_content "follow"
        expect(page).not_to have_content "unfollow"
        click_button "follow"
        expect(page).not_to have_content "unfollow"
        expect(page).to have_content "follow"
      end
    end

    context "自分の情報を見ている時" do
      scenario "編集ボタンが存在しない" do
      end

      scenario "follow/unfollowボタンがある" do
        visit user_path user.id
        expect(page).to have_current_path user_path user.id
        expect(page).not_to have_content "unfollow"
        expect(page).not_to have_content "unfollow"
      end
    end
  end
end
