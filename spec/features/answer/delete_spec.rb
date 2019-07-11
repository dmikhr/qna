require 'rails_helper'

feature 'User can delete his own answer' do
  given(:author_user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: author_user) }
  given!(:answer) { create(:answer, question: question, user: author_user) }

  scenario 'User deletes own answer' do
    sign_in(author_user)

    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
  end

  scenario "User can't delete answer from other user" do
    sign_in(another_user)

    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Delete answer')
  end

  scenario "Unauthenticated user can't delete answer" do
    visit question_path(question)

    expect(page).to_not have_selector(:link_or_button, 'Delete answer')
  end
end
