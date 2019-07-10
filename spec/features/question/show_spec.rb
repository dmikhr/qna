require 'rails_helper'

feature 'User can see a question and corresponding answers', %q{
  User visits a page with a question and see question
  and all answers corresponded to this question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question) }

  describe 'User' do

    background { visit question_path(question) }

    context 'see' do
      scenario 'the question' do
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end

      scenario 'answers to the question' do
        answers.each { |answer| expect(page).to have_content answer.body }
      end
    end

    context 'writes' do
      scenario 'answer to the question' do
        fill_in 'Body', with: 'This is answer to the question'
        click_on 'Write Answer'
        expect(page).to have_content "Answer was submitted successfully"
      end

      scenario 'empty answer to the question' do
        click_on 'Write Answer'
        expect(page).to have_content "Answer can't be empty"
      end
    end
  end
end
