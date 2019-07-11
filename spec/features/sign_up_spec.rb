require 'rails_helper'

feature 'User can sign up', %q{
  In order to create an account
} do

  describe 'User tries to sign up' do

    scenario 'and succseed' do
      sign_up(email = 'new_user@test.com',
              password = '12345678',
              password_confirmation = '12345678')

      expect(page).to have_content 'You have signed up successfully.'
    end

    scenario 'with no data entered' do
      sign_up(email = '',
              password = '',
              password_confirmation = '')

      expect(page.text).to match /prohibited this (.*) from being saved:/
    end

    scenario 'with incorrect password confirmation' do
      sign_up(email = 'new_user@test.com',
              password = '12345678',
              password_confirmation = '87654321')

      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    scenario 'with invalid email' do
      sign_up(email = 'invalid_email',
              password = '12345678',
              password_confirmation = '12345678')

      expect(page).to have_content "Sign up"
    end
  end
end
