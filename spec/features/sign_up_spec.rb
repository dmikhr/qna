require 'rails_helper'

feature 'User can sign up', %q{
  In order to create an account
} do
  describe 'User tries to sign up' do

    scenario 'and succseed' do
      visit new_user_registration_path
      fill_in 'Email', with: 'new_user@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'

      expect(page).to have_content 'You have signed up successfully.'
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
