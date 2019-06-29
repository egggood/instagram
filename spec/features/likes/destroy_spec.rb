require 'rails_helper'
require 'support/login_support'

RSpec.feature "Likes#destroy", type: :feature do
  context "ログインしていない時" do
    let(:user) { create(:user) }
    let(:micropost) { create(:micropost) }
    let(:like) { create(:like, micropost: micropost, user: user) }

    scenario "login_pathにリダイレクトする" do
      page.driver.submit(:delete, like_path(like.id), {})
      expect(page).to have_current_path login_path
    end
  end

  context "ログインしている時" do
    let(:user) { create(:user) }
    let(:micropost) { create(:micropost, user: user) }

    before do
      user.liking << [micropost]
      sign_in user
    end

    scenario "いいねを取り消す" do
      visit micropost_path micropost.id
      expect(page).to have_current_path micropost_path micropost.id
      expect(user.like?(micropost)).to be true
      expect(page).not_to have_button "いいね！"
      expect(page).to have_button "いいねを取り消す"

      click_button "いいねを取り消す"
      expect(page).to have_current_path micropost_path micropost.id
      expect(page).to have_button "いいね！"
      expect(page).not_to have_button "いいねを取り消す"
    end
  end
end
