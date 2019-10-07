require 'rails_helper'

feature 'User can select the best answer to his question', %q{
  In order to see the best answer
  on the top of an answers list
  I'd like ot be able to select the best answer
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question_without_reward) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 4, question: question, user: user) }
  given!(:answers2) { create_list(:answer, 4, question: question_without_reward, user: user) }
  given!(:reward) { create(:reward, rewardable: question) }

  scenario "Unauthenticated user can't select the best answer" do
    visit question_path(question)

    expect(page).to_not have_link 'Select as best'
  end

  describe 'User', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'selects answer as best' do

      within "div#answer_id_#{answers[-1].id}" do
        click_on 'Select as best'
        expect(page).to_not have_content 'Select as best'
      end

      answers[0, answers.size - 1].each do |answer|
        within "div#answer_id_#{answer.id}" do
          expect(page).to have_content 'Select as best'
        end
      end

      expect(page.find('.answers div:first-child')).to have_content answers[-1].body
    end

    scenario 'selects new answer as best' do

      within "div#answer_id_#{answers[-1].id}" do
        click_on 'Select as best'
      end

      within "div#answer_id_#{answers[0].id}" do
        click_on 'Select as best'
        expect(page).to_not have_content 'Select as best'
      end

      answers[1, answers.size].each do |answer|
        within "div#answer_id_#{answer.id}" do
          expect(page).to have_content 'Select as best'
        end
      end

      expect(page.find('.answers div:first-child')).to have_content answers[0].body
    end
  end

  scenario "tries to select the best answer of other user's question" do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_link 'Select as best'
  end

  scenario "User can select best answer for question without reward set", js: true do
    sign_in(user)
    visit question_path(question_without_reward)

    within "div#answer_id_#{answers2[-1].id}" do
      click_on 'Select as best'
      expect(page).to_not have_content 'Select as best'
    end

    answers2[0, answers.size - 1].each do |answer|
      within "div#answer_id_#{answer.id}" do
        expect(page).to have_content 'Select as best'
      end
    end

    expect(page.find('.answers div:first-child')).to have_content answers2[-1].body
  end
end
