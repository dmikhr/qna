require 'rails_helper'

feature 'Subscribe to new answers' do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'User', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'see subscribe link' do
      within '.subscription' do
        expect(page).to have_content 'Subscribe'
        expect(page).to_not have_content 'Unsubscribe'
      end
    end

    scenario 'click subscribe link' do
      within '.subscription' do
        click_on 'Subscribe'
        expect(page).to have_content 'Unsubscribe'
        expect(page).to_not have_content 'Subscribe'
      end
    end

    scenario 'click unsubscribe link' do
      within '.subscription' do
        click_on 'Subscribe'
        click_on 'Unsubscribe'
        expect(page).to have_content 'Subscribe'
        expect(page).to_not have_content 'Unsubscribe'
      end
    end
  end

  describe 'Author', js: true do

    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'already subscribed' do
      within '.subscription' do
        expect(page).to have_content 'Unsubscribe'
        expect(page).to_not have_content 'Subscribe'
      end
    end

    scenario 'can unsubscribe' do
      within '.subscription' do
        click_on 'Unsubscribe'
        expect(page).to have_content 'Subscribe'
        expect(page).to_not have_content 'Unsubscribe'
      end
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'cannot subscribe' do
      within '.subscription' do
        expect(page).to_not have_content 'Subscribe'
      end
    end

    scenario 'cannot unsubscribe' do
      within '.subscription' do
        expect(page).to_not have_content 'Unsubscribe'
      end
    end
  end
end
