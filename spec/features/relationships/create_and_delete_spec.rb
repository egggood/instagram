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
    let(:following) { create(:user) }

    before do
      sign_in user
    end

    scenario "followし、unfollowする" do
      visit user_path user.id
      expect(page).to have_current_path user_path user.id
      expect(page).to have_content "0 following"

      visit user_path following.id
      expect(page).to have_current_path user_path following.id
      expect(page).to have_button "follow"
      expect(page).to have_content "0 follower"
      click_button "follow"
      expect(page).to have_current_path user_path following.id
      expect(page).to have_content "1 follower"
      expect(page).to have_button "unfollow"

      visit user_path user.id
      expect(page).to have_current_path user_path user.id
      expect(page).to have_content "1 following"

      visit user_path following.id
      expect(page).to have_current_path user_path following.id
      expect(page).to have_content "1 follower"
      expect(page).to have_button "unfollow"
      click_button "unfollow"
      expect(page).to have_current_path user_path following.id
      expect(page).to have_content "0 followers"

      visit user_path user.id
      expect(page).to have_current_path user_path user.id
      expect(page).to have_content "0 followers"
    end
  end
end
