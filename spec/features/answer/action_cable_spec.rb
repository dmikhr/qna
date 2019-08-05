require 'rails_helper'

feature 'User can see new answers in real time', %q{
  In order to instantly see new answers
  As a user I'd like to be able to see new
  answers on the question page without reloading it
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Three users', js: true do
    scenario 'author posts answer, user and guest instantly see new answer' do
      Capybara.using_session('author') do
        sign_in(author)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('author') do
        fill_in 'Body', with: 'This is answer to the question'
        click_on 'Write Answer'

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content('This is answer to the question', count: 1)
        end
      end

      Capybara.using_session('user') do
        within '.answers' do
          expect(page).to have_content('This is answer to the question', count: 1)
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content('This is answer to the question', count: 1)
        end
      end
    end
  end
end
