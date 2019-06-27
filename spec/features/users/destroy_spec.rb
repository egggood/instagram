require 'rails_helper'
require 'support/login_support'

RSpec.feature "Users#destroy", type: :feature do
  context "ログインしていない時" do
    let(:user) { create(:user) }

    scenario "ログイン画面にredirectする" do
      page.driver.submit(:delete, user_path(user.id), {})
      expect(page).to have_current_path login_path
    end
  end

  context "ログインしている時" do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    scenario "削除する" do
      visit edit_user_path user.id
      click_link "Accountを削除する"
      expect(User.find_by(id: user.id)).to be nil
      expect(page).to have_current_path root_path
    end
  end
end
