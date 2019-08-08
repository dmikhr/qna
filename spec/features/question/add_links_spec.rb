require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:url) { 'https://edgeguides.rubyonrails.org/active_storage_overview.html' }
  given(:url2) { 'https://github.com/nathanvda/cocoon' }
  given(:gist_url) { 'https://gist.github.com/dmikhr/c7d219d8532bb4f55f53c57aefb1200f' }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question) }

  describe 'User adds link when asks question', js: true do
    scenario 'with valid url' do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: url

      click_on 'Ask'

      expect(page).to have_link 'My link', href: url
    end

    scenario 'with not valid url' do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: 'not a valid url'

      click_on 'Ask'

      expect(page).to have_content 'URL is not valid'
      expect(page).to_not have_content 'My link'
      expect(page).to_not have_content 'not a valid url'
    end

    scenario 'with gist url' do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_content 'Test gist qna'
      expect(page).to_not have_link 'My gist', href: gist_url
    end
  end

  describe 'User asks question', js: true do
    scenario 'and adds multiple links' do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: url

      click_on 'add link'

      within page.all('.nested-fields')[1] do
        fill_in 'Link name', with: 'My link 2'
        fill_in 'Url', with: url2
      end

      click_on 'Ask'

      expect(page).to have_link 'My link', href: url
      expect(page).to have_link 'My link 2', href: url2
    end
  end
end
