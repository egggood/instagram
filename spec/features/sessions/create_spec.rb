require 'rails_helper'

RSpec.feature "Sessions#new", type: :feature do
  context "DBに情報がないユーザー" do
    scenario "ログインに失敗する" do
      visit root_path
      click_link "ログイン"
      expect(page).to have_current_path login_path

      fill_in "User name", with: "にせの名前"
      fill_in "Password", with: "fake_password"
      click_button "ログインする"
      expect(page).to have_current_path login_path
      expect(page).to have_content "Invalid user_name/password conbination"
    end
  end

  context "DBに情報があるユーザー" do
    let(:user) { create(:user) }

    scenario "ログインに成功する" do
      visit root_path
      click_link "ログイン"
      expect(page).to have_current_path login_path

      fill_in "User name", with: user.user_name
      fill_in "Password", with: user.password
      click_button "ログインする"
      expect(page).to have_current_path user_path user.id
      expect(page).to have_content "ログインに成功しました^ ^"
    end

    scenario "誤った情報を入力し、ログインに失敗する" do
      visit root_path
      click_link "ログイン"
      expect(page).to have_current_path login_path

      fill_in "User name", with: nil
      fill_in "Password", with: nil
      click_button "ログインする"
      expect(page).to have_current_path login_path
      expect(page).to have_content "Invalid user_name/password conbination"
    end
  end
end
