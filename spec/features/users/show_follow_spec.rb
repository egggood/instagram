require 'rails_helper'
require 'support/login_support'

RSpec.feature "Sessions#new", type: :feature do
  let(:user) { create(:user) }

  context "ログインしていない時" do
    scenario "followsしているユーザー一覧を表示しようとするがlogin_pathにリダイレクトする" do
      visit followers_user_path user.id
      expect(page).to have_current_path login_path
    end

    scenario "followingのユーザー一覧を表示しようとするがlogin_pathにリダイレクトする" do
      visit following_user_path user.id
      expect(page).to have_current_path login_path
    end
  end

  context "ログインしている時" do
    let(:user) { create(:user) }
    let(:follower) { create(:user) }
    let(:following) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      sign_in user
      user.followers << [follower]
      user.following << [following]
    end

    scenario "followsしているユーザー一覧を表示する" do
      visit user_path user.id
      expect(page).to have_current_path user_path user.id

      click_link "followers"
      expect(page).to have_current_path followers_user_path user.id
      expect(page).to have_content follower.name
      expect(page).to have_content follower.user_name
      expect(page).to have_content follower.microposts.count
      expect(page).not_to have_content other_user.name
      expect(page).not_to have_content other_user.user_name

      click_link follower.name
      expect(page).to have_current_path user_path follower.id
      expect(page).to have_content follower.name
      expect(page).to have_content follower.user_name
      expect(page).to have_content follower.microposts.count
    end

    scenario "followingのユーザー一覧を表示する" do
      visit user_path user
      expect(page).to have_current_path user_path user.id

      click_link "following"
      expect(page).to have_current_path following_user_path user.id
      expect(page).to have_content following.name
      expect(page).to have_content following.user_name
      expect(page).to have_content following.microposts.count
      expect(page).not_to have_content other_user.name
      expect(page).not_to have_content other_user.user_name

      click_link following.name
      expect(page).to have_current_path user_path following.id
      expect(page).to have_content following.name
      expect(page).to have_content following.user_name
      expect(page).to have_content following.microposts.count
    end
  end
end
