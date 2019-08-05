require 'rails_helper'

feature 'User can see new questions in real time', %q{
  In order to instantly see new questions
  As a user I'd like to be able to see new
  questions without reloading page
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }

  describe 'Three users', js: true do
    scenario 'author creates question, user and guest instantly see new question' do
      Capybara.using_session('author') do
        sign_in(author)
        visit questions_path
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('author') do
        click_on 'Ask question'

        fill_in 'Title', with: 'Action Cable question'
        fill_in 'Body', with: 'some question text'
        click_on 'Ask'
      end

      Capybara.using_session('user') do
        expect(page).to have_content('Action Cable question', count: 1)
      end

      Capybara.using_session('guest') do
        expect(page).to have_content('Action Cable question', count: 1)
      end
    end
  end
end
