require 'sphinx_helper'

feature 'User can search for a question' do

  given(:user_creator) { create(:user, email: 'creator@creator.local') }
  given!(:user) { create(:user, email: 'keyword@test.com') }
  given!(:user2) { create(:user, email: 'another@test.com') }

  given!(:question) { create(:question, title: 'keyword written', user: user_creator) }
  given!(:question2) { create(:question, title: 'some keyword', user: user_creator) }
  given!(:question3) { create(:question, title: 'question another', user: user_creator) }

  given!(:answer) { create(:answer, body: 'keyword for answer', question: question, user: user_creator) }
  given!(:answer2) { create(:answer, body: 'answer another', question: question, user: user_creator) }

  given!(:comment) { create(:comment, body: 'keyword for comment', commentable: question, user: user_creator) }
  given!(:comment2) { create(:comment, body: 'comment another', commentable: question, user: user_creator) }
  given!(:comment_long) { create(:comment, body: 'this is a comment that contains long text', commentable: question, user: user_creator) }

  describe 'User search', sphinx: true, js: true do

    background { visit searches_path }

    scenario 'across all types of data' do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: 'keyword'

        click_on 'Find'

        within '.search_results' do
          expect(page).to have_link question.title, href: question_path(question)
          expect(page).to have_link question2.title, href: question_path(question2)
          expect(page).to have_content answer.body
          expect(page).to have_content comment.body
          expect(page).to have_content user.email

          expect(page).to_not have_link question3.title, href: question_path(question3)
          expect(page).to_not have_content answer2.body
          expect(page).to_not have_content comment2.body
          expect(page).to_not have_content user2.email
        end
      end
    end

    scenario 'across questions and comments' do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: 'keyword'

        page.check('question', option: true)
        page.check('comment', option: true)

        click_on 'Find'
        within '.search_results' do
          expect(page).to have_link question.title, href: question_path(question)
          expect(page).to have_link question2.title, href: question_path(question2)
          expect(page).to have_content comment.body

          expect(page).to_not have_content answer.body
          expect(page).to_not have_content user.email
        end
      end
    end

    scenario 'and result contains long text' do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: 'long'

        click_on 'Find'

        within '.search_results' do
          expect(page).to have_content "#{comment_long.body[0, 20]}..."
        end
      end
    end

    scenario 'with empty query' do
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: ''

        click_on 'Find'

        expect(page).to_not have_content 'Search results for'
      end
    end
  end
end
