require 'rails_helper'

feature 'User can vote for a question', %q{
  In order to express opinion about usefullness of a question
  As a user not being author of a question
  I'd like to be able to vote
} do

  given(:author) { create(:user) }
  given(:user_voter) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'User', js: true do

    background { sign_in(user_voter) }

    scenario 'upvotes for question' do
      visit question_path(question)

      within "div#vote_question_id_#{question.id}" do
        click_on 'Upvote'
        expect(page).to have_content 'Rating 1'
      end
    end

    scenario 'downvotes for question' do
      visit question_path(question)

      within "div#vote_question_id_#{question.id}" do
        click_on 'Downvote'
        expect(page).to have_content 'Rating -1'
      end
    end

    scenario 'cancels his vote' do
      visit question_path(question)

      within "div#vote_question_id_#{question.id}" do
        click_on 'Downvote'
        click_on 'Cancel vote'
        expect(page).to have_content 'Rating 0'
      end
    end

    scenario 'changes vote to opposite' do
      visit question_path(question)

      within "div#vote_question_id_#{question.id}" do
        click_on 'Downvote'
        click_on 'Cancel vote'
        click_on 'Upvote'
        expect(page).to have_content 'Rating 1'
      end
    end

    scenario 'tries to upvote twice' do
      visit question_path(question)

      within "div#vote_question_id_#{question.id}" do
        click_on 'Upvote'
        click_on 'Upvote'
        expect(page).to have_content 'Rating 1'
      end
    end

    scenario 'tries to downvote twice' do
      visit question_path(question)

      within "div#vote_question_id_#{question.id}" do
        click_on 'Downvote'
        click_on 'Downvote'
        expect(page).to have_content 'Rating -1'
      end
    end
  end

  describe 'Author tries to', js: true do

    background { sign_in(author) }

    scenario 'upvote for question' do
      visit question_path(question)

      expect(page).to_not have_content 'Upvote'
    end

    scenario 'downvote for question' do
      visit question_path(question)

      expect(page).to_not have_content 'Downvote'
    end

    scenario 'cancel his vote' do
      visit question_path(question)

      expect(page).to_not have_content 'Cancel vote'
    end
  end

  describe 'Unauthorized user tries to', js: true do
    scenario 'upvote for question' do
      visit question_path(question)

      expect(page).to_not have_content 'Upvote'
    end

    scenario 'downvote for question' do
      visit question_path(question)

      expect(page).to_not have_content 'Downvote'
    end

    scenario 'cancel his vote' do
      visit question_path(question)

      expect(page).to_not have_content 'Cancel vote'
    end
  end
end
