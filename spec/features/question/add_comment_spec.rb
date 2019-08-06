require 'rails_helper'

feature 'User can submit comment to a question' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do

    background { sign_in(user) }

    scenario 'submit comment to the question' do
      visit question_path(question)

      within ".add-comment-question" do
        fill_in 'Body', with: 'This is comment to the question'
        click_on 'Add comment'
      end

      within ".question-comments" do
        expect(page).to have_content 'This is comment to the question'
      end
    end

    scenario 'tries to submit empty comment to the question' do
      visit question_path(question)

      within ".add-comment-question" do
        click_on 'Add comment'
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario "Unauthenticated user can't submit comment to the question" do
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Add comment')
  end
end
