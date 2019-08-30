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
      within "div#answer_id_#{answer.id}" do
        click_on 'Edit'

        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        within '.edit-answer' do
          expect(page).to_not have_selector 'textarea'
        end
      end
    end

    scenario 'edits his answer with errors' do
      within "div#answer_id_#{answer.id}" do
        click_on 'Edit'

        fill_in 'Your answer', with: ''
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'add files to his edited answer' do
      within "div#answer_id_#{answer.id}" do
        click_on 'Edit'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'add link while editing answer' do
      within "div#answer_id_#{answer.id}" do
        click_on 'Edit'

        click_on 'add link'

        fill_in 'Link name', with: 'My link 2'
        fill_in 'Url', with: 'https://2nd-url.com/page'

        click_on 'Save'

        expect(page).to have_link 'My link 2', href: 'https://2nd-url.com/page', visible: false
      end
    end
  end

  scenario "tries to edit other user's answer" do
    sign_in(user2)
    visit question_path(question)

    within ".answers" do
      expect(page).to_not have_link 'Edit'
    end
  end

end
