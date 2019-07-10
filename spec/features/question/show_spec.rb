require 'rails_helper'

feature 'User can see a question and corresponding answers', %q{
  User visits a page with a question and see question
  and all answers corresponded to this question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question) }

  describe 'User' do

    background { visit question_path(question) }

    scenario 'see the question' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'see answers to the question' do
      answers.each { |answer| expect(page).to have_content answer.body }
    end

    scenario "can't write answer without authenticating" do
      expect(page).to_not have_selector(:link_or_button, 'Write Answer')
      expect(page).to have_content "Log In in order to write an answer"
    end
  end

  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'writes answer to the question' do
      fill_in 'Body', with: 'This is answer to the question'
      click_on 'Write Answer'
      expect(page).to have_content 'This is answer to the question'
    end

    scenario 'tries to submit empty answer' do
      click_on 'Write Answer'
      expect(page).to have_content "Answer can't be empty"
    end
  end
end
