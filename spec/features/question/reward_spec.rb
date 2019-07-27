require 'rails_helper'

feature 'User can add reward to question', %q{
  In order to reward author of the best answer
  As an question's author
  I'd like to be able to set a reward
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:user_rewarded) { create(:user) }
  given!(:question) { create(:question, user: author) }

  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer_best) { create(:answer, question: question, user: user_rewarded) }

  let!(:reward) { create(:reward, :with_picture, rewardable: question) }

  describe 'Author', js: true do
    scenario 'adds reward when asks question' do
      sign_in(author)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Reward name', with: 'My Reward'
      attach_file 'Picture', "#{Rails.root}/app/assets/images/reward_medal.png"

      click_on 'Ask'

      expect(page).to have_content 'Reward was set'
    end

    scenario 'rewards the author of the best answer' do
      sign_in(author)
      visit question_path(question)

      within "#answer_id_#{answer_best.id}" do
        click_on 'Select as best'
      end

      click_on 'Log Out'
      sign_in(user_rewarded)
      click_on 'My Rewards'

      expect(page).to have_content reward.name
      expect(page).to have_content question.title
      expect(page).to have_css("img[src*='reward_medal.png']")
      # save_and_open_screenshot для визуального контроля, что изображение загрузилось
      # save_and_open_screenshot
    end
  end
end
