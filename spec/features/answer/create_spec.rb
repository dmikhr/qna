require 'rails_helper'

feature 'User can submit answer to a question', %q{
  User visits a page with a question
  and post answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'submit answer to the question' do
      fill_in 'Body', with: 'This is answer to the question'
      click_on 'Write Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'This is answer to the question'
      end
    end

    scenario 'tries to submit empty answer' do
      click_on 'Write Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Unauthenticated user can't submit answer" do
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Write Answer')
    expect(page).to have_content "Log In in order to write an answer"
  end
end
