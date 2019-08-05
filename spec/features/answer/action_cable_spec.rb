require 'rails_helper'

feature 'User can see new answers in real time', %q{
  In order to instantly see new answers
  As a user I'd like to be able to see new
  answers on the question page without reloading it
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:url) { 'https://edgeguides.rubyonrails.org/active_storage_overview.html' }
  given(:gist_url) { 'https://gist.github.com/dmikhr/c7d219d8532bb4f55f53c57aefb1200f' }

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

        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: url

        click_on 'add link'

        page.all('.nested-fields')[1].fill_in 'Link name', with: 'My gist'
        page.all('.nested-fields')[1].fill_in 'Url', with: gist_url

        click_on 'Write Answer'

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content('This is answer to the question', count: 1)

          expect(page).to_not have_content 'Select as best'

          expect(page).to_not have_content 'Upvote'
          expect(page).to_not have_content 'Cancel vote'
          expect(page).to_not have_content 'Downvote'

          expect(page).to have_link 'My link', href: url
          expect(page).to_not have_link 'My gist', href: gist_url
          expect(page).to have_content 'Test gist qna'
        end
      end

      Capybara.using_session('user') do
        within '.answers' do
          expect(page).to have_content('This is answer to the question', count: 1)

          expect(page).to have_content 'Select as best'

          expect(page).to have_content 'Upvote'
          expect(page).to have_content 'Cancel vote'
          expect(page).to have_content 'Downvote'

          expect(page).to have_link 'My link', href: url
          expect(page).to_not have_link 'My gist', href: gist_url
          expect(page).to have_content 'Test gist qna'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content('This is answer to the question', count: 1)
          expect(page).to_not have_content 'Select as best'

          expect(page).to_not have_content 'Upvote'
          expect(page).to_not have_content 'Cancel vote'
          expect(page).to_not have_content 'Downvote'

          expect(page).to have_link 'My link', href: url
          expect(page).to_not have_link 'My gist', href: gist_url
          expect(page).to have_content 'Test gist qna'
        end
      end
    end
  end
end