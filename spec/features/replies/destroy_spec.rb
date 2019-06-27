require 'rails_helper'
require 'support/login_support'

RSpec.feature "Reply#destroy", type: :feature do
  context "ログインしていない時" do
    let(:micropost) { create(:micropost) }

    scenario "ログイン画面にredirectする" do
      page.driver.submit(:delete, reply_path(micropost.id), {})
      expect(page).to have_current_path login_path
    end
  end

  context "ログインしている時" do
    let(:user) { create(:user) }
    let(:reply) { create(:reply) }
    let(:micropost) { create(:micropost, user: user, reply: [reply]) }

    before do
      sign_in user
    end

    scenario "投稿を削除する" do
      visit micropost_path micropost.id
      expect(page).to have_current_path micropost_path micropost.id
      expect(page).to have_content reply.content

      click_button "返信を削除する"
      expect(Reply.find_by(id: reply.id)).to be nil
      expect(page).to have_current_path micropost_path micropost.id
      expect(page).not_to have_content reply.content
      expect(page).to have_content "返信の削除に成功しました"
    end
  end
end
