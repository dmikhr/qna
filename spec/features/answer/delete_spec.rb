require 'rails_helper'

feature 'User can delete his own answer' do
  given(:author_user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: author_user) }
  given!(:answer) { create(:answer, question: question, user: author_user) }

  scenario 'User deletes own answer', js: true do
    sign_in(author_user)

    visit question_path(question)

    within "div#answer_id_#{answer.id}" do
      click_on 'Delete answer'
    end

    expect(page).to_not have_content answer.body
  end

  scenario "User can't delete answer from other user", js: true do
    sign_in(another_user)

    visit question_path(question)

    within "div#answer_id_#{answer.id}" do
      expect(page).to_not have_selector(:link_or_button, 'Delete answer')
    end
  end

  scenario "Unauthenticated user can't delete answer", js: true do
    visit question_path(question)

    within "div#answer_id_#{answer.id}" do
      expect(page).to_not have_selector(:link_or_button, 'Delete answer')
    end
  end
end
