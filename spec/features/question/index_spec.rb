require 'rails_helper'

feature 'User can see a list of questions' do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 10, user: user) }

  scenario 'see questions list' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end
