require 'rails_helper'

feature 'User can vote for an answer', %q{
  In order to express opinion about usefullness of an answer
  As a user not being author of an answer
  I'd like to be able to vote
} do

  given(:author) { create(:user) }
  given(:user_voter) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 2, question: question, user: author) }

  describe 'User', js: true do
    scenario 'upvotes for answer' do
      sign_in(user_voter)
      visit question_path(question)

      within "div#vote_answer_id_#{answers[0].id}" do
        click_on 'Upvote'
        expect(page).to have_content 'Rating 1'
      end
    end

    scenario 'downvotes for answer' do
      sign_in(user_voter)
      visit question_path(question)

      within "div#vote_answer_id_#{answers[0].id}" do
        click_on 'Downvote'
        expect(page).to have_content 'Rating -1'
      end
    end

    scenario 'cancels his vote' do
      sign_in(user_voter)
      visit question_path(question)

      within "div#vote_answer_id_#{answers[0].id}" do
        click_on 'Downvote'
        click_on 'Cancel vote'
        expect(page).to have_content 'Rating 0'
      end
    end

    scenario 'changes vote to opposite' do
      sign_in(user_voter)
      visit question_path(question)

      within "div#vote_answer_id_#{answers[0].id}" do
        click_on 'Downvote'
        click_on 'Upvote'
        expect(page).to have_content 'Rating 1'
      end
    end
  end
end
