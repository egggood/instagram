require 'rails_helper'

RSpec.feature "Users", type: :feature do
  let(:user) { build(:user) }

  scenario "ユーザーの登録に成功する" do
    visit root_path
    expect(page).to have_current_path root_path

    click_link "新規登録"
    expect(page).to have_current_path new_user_path
    fill_in "フルネーム", with: user.name
    fill_in "User name", with: user.user_name
    fill_in "Password", with: user.password
    fill_in "確認用", with: user.password_confirmation
    click_button "登録する"

    expect(page).to have_current_path user_path(User.find_by(name: user.name).id)
    expect(page).to have_content user.name
    expect(page).to have_content user.user_name
    expect(page).to have_content "登録に成功しました!"
  end

  scenario "ユーザーの登録に失敗する" do
    visit root_path
    expect(page).to have_current_path root_path

    click_link "新規登録"
    expect(page).to have_current_path new_user_path
    fill_in "フルネーム", with: nil
    fill_in "User name", with: user.user_name
    fill_in "Password", with: user.password
    fill_in "確認用", with: user.password_confirmation
    click_button "登録する"

    expect(page).to have_current_path users_path
    expect(page).to have_content "Name can't be blank"
  end
end
