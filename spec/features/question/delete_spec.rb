require 'rails_helper'

feature 'User can delete his own question' do
  given!(:author_user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: author_user) }

  scenario 'User deletes own question', js: true do
    sign_in(author_user)

    visit questions_path

    within "div#question_id_#{question.id}" do
      click_on 'Delete question'
    end
    expect(page).to_not have_content question.title
  end

  scenario "User can't delete question from other user", js: true do
    sign_in(another_user)

    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Delete question')
  end

  scenario "Unauthenticated user can't delete question", js: true do
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Delete question')
  end
end
