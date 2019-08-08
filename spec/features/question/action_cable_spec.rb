require 'rails_helper'

feature 'User can see new questions in real time', %q{
  In order to instantly see new questions
  As a user I'd like to be able to see new
  questions without reloading page
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

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

  describe 'Comments', js: true do
    scenario 'one user posts comment , another instantly see it' do
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
        within ".add-comment-question" do
          fill_in 'Body', with: 'This is comment to the question'
          click_on 'Add comment'
        end

        within ".question-comments" do
          expect(page).to have_content('This is comment to the question', count: 1)
        end
      end

      Capybara.using_session('user') do
        within ".question-comments" do
          expect(page).to have_content('This is comment to the question', count: 1)
        end
      end

      Capybara.using_session('guest') do
        within ".question-comments" do
          expect(page).to have_content('This is comment to the question', count: 1)
        end
      end
    end
  end
end
