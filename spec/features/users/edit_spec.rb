require 'rails_helper'
require 'support/login_support'

RSpec.feature "Users#edit", type: :feature do
  context "ログインしていない時" do
    let(:user) { create(:user) }

    scenario "ログイン画面にredirectする" do
      visit edit_user_path user.id
      expect(page).to have_current_path login_path
    end
  end

  context "ログインしている時" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      sign_in user
    end

    context "違うuserの情報を編集しようとする時" do
      scenario "編集ボタンが存在しない" do
        visit edit_user_path other_user.id
        expect(page).to have_current_path root_path
      end
    end

    context "自分の情報を更新する時" do
      let(:old_name) { user.name }
      let(:old_user_name) { user.user_name }
      let(:old_self_introduction) { user.self_introduction }

      scenario "更新に成功する" do
        visit edit_user_path user.id
        expect(page).to have_current_path edit_user_path user.id

        fill_in "user_name", with: "テストユーザー"
        fill_in "user_user_name", with: "test_user"
        fill_in "user_self_introduction", with: "私はテストユーザーです"
        click_button "更新する"
        expect(page).to have_current_path user_path user.id
        expect(page).to have_content "テストユーザー"
        expect(page).to have_content "test_user"
        expect(page).to have_content "私はテストユーザーです"
        expect(page).to have_content "更新に成功しました！"
        expect(page).not_to have_content old_name
        expect(page).not_to have_content old_user_name
        expect(page).not_to have_content old_self_introduction
      end

      scenario "更新に失敗する" do
        visit edit_user_path user.id
        expect(page).to have_current_path edit_user_path user.id

        fill_in "user_name", with: nil
        click_button "更新する"
        expect(page).to have_current_path user_path user.id
        expect(page).to have_content "Name can't be blank"
      end
    end
  end
end
