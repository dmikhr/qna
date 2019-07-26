require 'rails_helper'

feature 'User can delete links from question', %q{
  In order to remove unnecessary links
  As an question's author
  I'd like to be able to delete links
} do

  given(:question_author_user) { create(:user) }
  given(:answer_author_user) { create(:user) }
  given!(:question) { create(:question, user: question_author_user) }
  given!(:answer) { create(:answer, question: question, user: answer_author_user) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'Author deletes link from answer', js: true do
    sign_in(answer_author_user)
    visit question_path(question)

    within "div#answer_id_#{answer.id}" do
      within "div#link_id_#{link.id}" do
        expect(page).to have_link link.name, href: link.url
        click_on 'Delete link'
      end
    end
    expect(page).to_not have_link link.name, href: link.url
  end

  scenario "User can't delete link from answer that isn't his", js: true do
    sign_in(question_author_user)
    visit question_path(question)

    within "div#answer_id_#{answer.id}" do
      expect(page).to have_link link.name, href: link.url
      expect(page).to_not have_content 'Delete link'
    end
  end

  scenario "Unauthenticated user can't delete link from answer", js: true do
    visit question_path(question)

    within "div#answer_id_#{answer.id}" do
      expect(page).to have_link link.name, href: link.url
      expect(page).to_not have_content 'Delete link'
    end
  end
end
