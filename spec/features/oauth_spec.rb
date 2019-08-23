require 'rails_helper'

feature 'User can sign in with 3rd party OAuth provider' do
  background { visit new_user_session_path }
  given!(:user_registered) { create(:user, email: 'registered@user.com') }

  describe 'User sign in through Github' do
    scenario "OAuth provider has user's email" do
      mock_auth(:github, 'new@user.com')
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from github account.'
    end

    scenario "OAuth provider has user's email and user has an account" do
      mock_auth(:github, 'registered@user.com')
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from github account.'
    end

    scenario "OAuth provider doesn't have user's email" do
      # 'email: nil' решил указать явно в виде аргумента для наглядности тестов
      mock_auth(:github, email: nil)
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'In order to proceed with sign up enter your email'
      fill_in 'email', with: 'new@user.com'
      click_on 'Submit'

      open_email('new@user.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    # случай, когда OAuth провайдер не имеет email пользователя, но
    # после ввода email оказывается, что такой пользователь в БД есть - тогда подтверждение не нужно
    scenario "OAuth provider doesn't have user's email but user have an account" do
      mock_auth(:github, email: nil)
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'In order to proceed with sign up enter your email'
      fill_in 'email', with: 'registered@user.com'
      click_on 'Submit'

      expect(page).to have_content 'You can sign up'
    end
  end

  describe 'User sign in through Vkontakte' do
    scenario "OAuth provider has user's email" do
      mock_auth(:vkontakte, 'new@user.com')
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from vkontakte account.'
    end

    scenario "OAuth provider has user's email and user has an account" do
      mock_auth(:vkontakte, 'registered@user.com')
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from vkontakte account.'
    end

    scenario "OAuth provider doesn't have user's email" do
      mock_auth(:vkontakte, email: nil)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'In order to proceed with sign up enter your email'
      fill_in 'email', with: 'new@user.com'
      click_on 'Submit'

      open_email('new@user.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario "OAuth provider doesn't have user's email but user have an account" do
      mock_auth(:vkontakte, email: nil)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'In order to proceed with sign up enter your email'
      fill_in 'email', with: 'registered@user.com'
      click_on 'Submit'

      expect(page).to have_content 'You can sign up'
    end
  end
end
