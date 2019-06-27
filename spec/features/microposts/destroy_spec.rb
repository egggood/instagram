require 'rails_helper'
require 'support/login_support'

RSpec.feature "Reply#destroy", type: :feature do
  context "ログインしていない時" do
    let(:micropost) { create(:micropost) }

    scenario "ログイン画面にredirectする" do
      page.driver.submit(:delete, micropost_path(micropost.id), {})
      expect(page).to have_current_path login_path
    end
  end

  context "ログインしている時" do
    let(:user) { create(:user) }
    let(:micropost) { create(:micropost, user: user) }
    let(:other_user) { create(:user) }
    let(:micropost_belong_to_other) { create(:micropost, user: other_user) }

    before do
      sign_in user
    end

    scenario "自分の投稿を削除する" do
      visit micropost_path micropost.id
      click_link "投稿を削除する"
      expect(Micropost.find_by(id: micropost.id)).to be nil
      expect(page).to have_current_path user_path user.id
    end

    scenario "他人の投稿では削除ボタンが表示されない" do
      visit micropost_path micropost_belong_to_other.id
      expect(page).to have_current_path micropost_path micropost_belong_to_other.id
      expect(page).not_to have_content "投稿を削除する"
    end
  end
end
