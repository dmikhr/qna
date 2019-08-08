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
      within '.add-answer' do
        fill_in 'Body', with: 'This is answer to the question'
        click_on 'Write Answer'
      end

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'This is answer to the question'
      end
    end

    scenario 'tries to submit empty answer' do
      within '.add-answer' do
        click_on 'Write Answer'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'submit answer with attached files' do
      within '.add-answer' do
        fill_in 'Body', with: 'This is answer to the question'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Write Answer'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario "Unauthenticated user can't submit answer" do
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Write Answer')
    expect(page).to have_content "Log In in order to write an answer"
  end
end
