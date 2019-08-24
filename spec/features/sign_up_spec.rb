require 'rails_helper'

feature 'User can sign up', %q{
  In order to create an account
  and be able to ask questions
  and post answers
} do

  describe 'User tries to sign up' do

    scenario 'and succseed' do
      visit new_user_registration_path
      fill_in 'Email', with: 'new_user@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'

      expect(page).to have_content 'A message with a confirmation link has been sent to your email address'

      open_email('new_user@test.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'with no data entered' do
      visit new_user_registration_path
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: ''
      click_on 'Sign up'

      expect(page.text).to match /prohibited this (.*) from being saved:/
    end

    scenario 'with incorrect password confirmation' do
      visit new_user_registration_path
      fill_in 'Email', with: 'new_user@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '87654321'
      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    scenario 'with invalid email' do
      visit new_user_registration_path
      fill_in 'Email', with: 'invalid_email'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'

      expect(page).to have_content "Sign up"
    end
  end
end
