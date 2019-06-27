require 'rails_helper'
require 'support/login_support'

RSpec.feature "Likes#create", type: :feature do
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

    scenario "いいねに成功する" do
      visit micropost_path micropost.id
      expect(page).to have_current_path micropost_path micropost.id
      expect(page).to have_button "いいね！"
      expect(page).not_to have_button "いいねを取り消す"

      click_button "いいね！"
      expect(page).to have_current_path micropost_path micropost.id
      expect(page).to have_content "いいねしました！"
      expect(page).not_to have_button "いいね！"
      expect(page).to have_button "いいねを取り消す"
    end
  end
end
