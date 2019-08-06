require 'rails_helper'

feature 'User can submit comment to an answer' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do

    background { sign_in(user) }

    scenario 'submit comment to the answer' do
      visit question_path(question)

      within "div#answer_id_#{answer.id}" do
        within ".add-comment-answer" do
          fill_in 'Body', with: 'This is comment to the answer'
          click_on 'Add comment'
        end
      end

      within ".answer-comments" do
        expect(page).to have_content 'This is comment to the answer'
      end
    end

    scenario 'tries to submit empty comment to the answer' do
      visit question_path(question)

      within "div#answer_id_#{answer.id}" do
        within ".add-comment-answer" do
          click_on 'Add comment'
          expect(page).to have_content "Body can't be blank"
        end
      end
    end
  end

  scenario "Unauthenticated user can't submit comment to the answer" do
    visit question_path(question)

    within "div#answer_id_#{answer.id}" do
      expect(page).to_not have_selector(:link_or_button, 'Add comment')
    end
  end
end
