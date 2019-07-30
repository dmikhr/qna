require 'rails_helper'

feature 'User can delete links from question', %q{
  In order to remove unnecessary links
  As an question's author
  I'd like to be able to delete links
} do

  given(:author_user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: author_user) }
  given!(:link) { create(:link, linkable: question) }

  scenario 'Author deletes link from question', js: true do
    sign_in(author_user)
    visit question_path(question)
    expect(page).to have_link link.name, href: link.url

    within "div#link_id_#{link.id}" do
      click_on 'Delete link'
    end
    expect(page).to_not have_link link.name, href: link.url
  end

  scenario "User can't delete link from question that isn't his", js: true do
    sign_in(another_user)
    visit question_path(question)
    expect(page).to have_link link.name, href: link.url
    within "div#link_id_#{link.id}" do
      expect(page).to_not have_content 'Delete link'
    end
  end

  scenario "Unauthenticated user can't delete link from question", js: true do
    visit question_path(question)

    within "div#link_id_#{link.id}" do
      expect(page).to_not have_selector(:link_or_button, 'Delete link')
    end
  end
end
