module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user ? user.email : 'wrong_user@test.com'
    fill_in 'Password', with: user ? user.password : '222222222'
    click_on 'Log in'
  end

  def sign_up(email, password, password_confirmation)
    visit new_user_registration_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation
    click_on 'Sign up'
  end
end
