module LoginSupport
  def sign_in(user)
    visit login_path
    fill_in "User name", with: user.user_name
    fill_in "Password", with: user.password
    click_button "ログインする"
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
