require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'edits his question' do
      within "div#question_id_#{question.id}" do
        click_on 'Edit question'

        fill_in 'Question title', with: 'edited question title'
        fill_in 'Question body', with: 'edited question body'
        click_on 'Save question'
        # all tests work fine with default Capbara waiting time,
        # this is just to try custom delay helper in action
        wait_for_ajax

        expect(page).to have_content 'edited question title'
        expect(page).to have_selector 'textarea', text: 'edited question body', visible: false
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      within "div#question_id_#{question.id}" do
        click_on 'Edit question'

        fill_in 'Question title', with: ''
        fill_in 'Question body', with: ''
        click_on 'Save question'

        expect(page).to_not have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'add files to edited question' do
      within "div#question_id_#{question.id}" do
        click_on 'Edit question'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save question'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'add link while editing question' do
      within "div#question_id_#{question.id}" do
        click_on 'Edit question'

        click_on 'add link'

        fill_in 'Link name', with: 'My link 2'
        fill_in 'Url', with: 'https://2nd-url.com/page'

        click_on 'Save question'

        expect(page).to have_link 'My link 2', href: 'https://2nd-url.com/page', visible: false
      end
    end
  end

  scenario "tries to edit other user's question" do
    sign_in(user2)
    visit questions_path

    expect(page).to_not have_link 'Edit question'
  end
end
