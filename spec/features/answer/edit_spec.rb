require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      click_on 'Edit'

      within "div#answer_id_#{answer.id}" do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      click_on 'Edit'

      within "div#answer_id_#{answer.id}" do
        fill_in 'Your answer', with: ''
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario "tries to edit other user's question" do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

end
