require 'rails_helper'

feature 'User can see a question and corresponding answers', %q{
  User visits a page with a question and see question
  and all answers corresponded to this question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, question: question, user: user) }
  given!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
  given!(:comments_answer) { create_list(:comment, 3, commentable: answers[0], user: user) }

  describe 'User' do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'see the question' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'see answers to the question' do
      answers.each { |answer| expect(page).to have_content answer.body }
    end

    scenario "see new answers below older" do
      answers.each_cons(2).all? { |older, newer| page_location(older.body) < page_location(newer.body) }
    end

    scenario 'see comments to the question' do
      visit question_path(question)

      within '.question-comments' do
        comments.each { |comment| expect(page).to have_content comment.body }
      end
    end

    scenario 'see comments to the answer' do
      visit question_path(question)

      within "div#answer_id_#{answers[0].id}" do
        comments_answer.each { |comment| expect(page).to have_content comment.body }
      end
    end
  end
end
