require 'rails_helper'

feature 'User can see new answers in real time', %q{
  In order to instantly see new answers
  As a user I'd like to be able to see new
  answers on the question page without reloading it
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:url) { 'https://edgeguides.rubyonrails.org/active_storage_overview.html' }
  given(:gist_url) { 'https://gist.github.com/dmikhr/c7d219d8532bb4f55f53c57aefb1200f' }

  describe 'Three users', js: true do
    scenario 'author posts answer, user and guest instantly see new answer' do
      Capybara.using_session('author') do
        sign_in(author)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('author') do
        within '.add-answer' do
          fill_in 'Body', with: 'This is answer to the question'

          fill_in 'Link name', with: 'My link'
          fill_in 'Url', with: url

          click_on 'add link'

          within page.all('.nested-fields')[1] do
            fill_in 'Link name', with: 'My gist'
            fill_in 'Url', with: gist_url
          end

          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

          click_on 'Write Answer'
        end

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content('This is answer to the question', count: 1)

          expect(page).to_not have_content 'Select as best'

          expect(page).to_not have_content 'Upvote'
          expect(page).to_not have_content 'Cancel vote'
          expect(page).to_not have_content 'Downvote'

          expect(page).to have_link 'My link', href: url
          expect(page).to_not have_link 'My gist', href: gist_url
          expect(page).to have_content 'Test gist qna'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      Capybara.using_session('user') do
        within '.answers' do
          expect(page).to have_content('This is answer to the question', count: 1)

          expect(page).to have_content 'Select as best'

          expect(page).to have_content 'Upvote'
          expect(page).to have_content 'Cancel vote'
          expect(page).to have_content 'Downvote'

          expect(page).to have_link 'My link', href: url
          expect(page).to_not have_link 'My gist', href: gist_url
          expect(page).to have_content 'Test gist qna'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content('This is answer to the question', count: 1)
          expect(page).to_not have_content 'Select as best'

          expect(page).to_not have_content 'Upvote'
          expect(page).to_not have_content 'Cancel vote'
          expect(page).to_not have_content 'Downvote'

          expect(page).to have_link 'My link', href: url
          expect(page).to_not have_link 'My gist', href: gist_url
          expect(page).to have_content 'Test gist qna'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end
  end

  describe 'Users see answers', js: true do
    given(:question1) { create(:question, user: user) }
    given(:question2) { create(:question, user: user) }

    scenario 'only to corresponded question' do
      Capybara.using_session('author_of_question1') do
        sign_in(author)
        visit question_path(question1)
      end

      Capybara.using_session('viewer_of_question1') do
        visit question_path(question1)
      end

      Capybara.using_session('viewer_of_question2') do
        visit question_path(question2)
      end

      Capybara.using_session('author_of_question1') do
        within '.add-answer' do
          fill_in 'Body', with: 'This is answer to the question'
          click_on 'Write Answer'
        end

        within '.answers' do
          expect(page).to have_content('This is answer to the question', count: 1)
        end
      end

      Capybara.using_session('viewer_of_question1') do
        within '.answers' do
          expect(page).to have_content('This is answer to the question', count: 1)
        end
      end

      Capybara.using_session('viewer_of_question2') do
        expect(page).to_not have_content 'This is answer to the question'
      end
    end
  end

  describe 'Comments', js: true do
    given!(:answer) { create(:answer, question: question, user: user) }
    scenario 'one user posts comment, another instantly see it' do
      Capybara.using_session('author') do
        sign_in(author)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('author') do
        within "div#answer_id_#{answer.id}" do
          within ".add-comment-answer" do
            fill_in 'Body', with: 'This is comment to the answer'
            click_on 'Add comment'
          end
        end
        within ".answer-comments" do
          expect(page).to have_content('This is comment to the answer', count: 1)
        end
      end

      Capybara.using_session('user') do
        within "div#answer_id_#{answer.id}" do
          expect(page).to have_content('This is comment to the answer', count: 1)
        end
      end

      Capybara.using_session('guest') do
        within "div#answer_id_#{answer.id}" do
          expect(page).to have_content('This is comment to the answer', count: 1)
        end
      end
    end
  end
end
