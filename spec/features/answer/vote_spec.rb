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

    background { sign_in(user_voter) }

    scenario 'upvotes for answer' do
      visit question_path(question)

      within "div#vote_answer_id_#{answers[0].id}" do
        click_on 'Upvote'
        expect(page).to have_content 'Rating 1'
      end
    end

    scenario 'downvotes for answer' do
      visit question_path(question)

      within "div#vote_answer_id_#{answers[0].id}" do
        click_on 'Downvote'
        expect(page).to have_content 'Rating -1'
      end
    end

    scenario 'cancels his vote' do
      visit question_path(question)

      within "div#vote_answer_id_#{answers[0].id}" do
        click_on 'Downvote'
        click_on 'Cancel vote'
        expect(page).to have_content 'Rating 0'
      end
    end

    scenario 'changes vote to opposite' do
      visit question_path(question)

      within "div#vote_answer_id_#{answers[0].id}" do
        click_on 'Downvote'
        click_on 'Cancel vote'
        click_on 'Upvote'
        expect(page).to have_content 'Rating 1'
      end
    end

    scenario 'tries to upvote twice' do
      visit question_path(question)

      within "div#vote_answer_id_#{answers[0].id}" do
        click_on 'Upvote'
        click_on 'Upvote'
        expect(page).to have_content 'Rating 1'
      end
    end

    scenario 'tries to downvote twice' do
      visit question_path(question)

      within "div#vote_answer_id_#{answers[0].id}" do
        click_on 'Downvote'
        click_on 'Downvote'
        expect(page).to have_content 'Rating -1'
      end
    end
  end

  describe 'Author tries to', js: true do

    background { sign_in(author) }

    scenario 'upvotes for answer' do
      visit question_path(question)

      within "div#answer_id_#{answers[0].id}" do
        expect(page).to_not have_content 'Upvote'
      end
    end

    scenario 'downvotes for answer' do
      visit question_path(question)

      within "div#answer_id_#{answers[0].id}" do
        expect(page).to_not have_content 'Downvote'
      end
    end

    scenario 'cancels his vote' do
      visit question_path(question)

      within "div#answer_id_#{answers[0].id}" do
        expect(page).to_not have_content 'Cancel vote'
      end
    end
  end

  describe 'Unauthorized user tries to', js: true do

    scenario 'upvotes for answer' do
      visit question_path(question)

      within "div#answer_id_#{answers[0].id}" do
        expect(page).to_not have_content 'Upvote'
      end
    end

    scenario 'downvotes for answer' do
      visit question_path(question)

      within "div#answer_id_#{answers[0].id}" do
        expect(page).to_not have_content 'Downvote'
      end
    end

    scenario 'cancels his vote' do
      visit question_path(question)

      within "div#answer_id_#{answers[0].id}" do
        expect(page).to_not have_content 'Cancel vote'
      end
    end
  end
end
