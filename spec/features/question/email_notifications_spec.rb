require 'rails_helper'

feature 'Get email notifications about new answers' do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Email notifications', js: true do
    before { Sidekiq::Testing.inline! }

    context 'author' do
      scenario 'get notified about new answers' do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)

          within '.add-answer' do
            fill_in 'Body', with: 'This is answer to the question'
            click_on 'Write Answer'
          end
        end

        Capybara.using_session('author') do
          sleep(1)
          open_email(author.email)
          expect(current_email).to have_content 'There is a new answer to a subscribed question'
        end
      end

      scenario 'does not get notified about new answers if unsubscribed' do
        Capybara.using_session('author') do
          sign_in(author)
          visit question_path(question)
          click_on 'Unsubscribe'
        end

        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)

          within '.add-answer' do
            fill_in 'Body', with: 'This is answer to the question'
            click_on 'Write Answer'
          end
        end

        Capybara.using_session('author') do
          sleep(1)
          open_email(author.email)
          expect(current_email).to_not have_content 'There is a new answer to a subscribed question'
        end
      end
    end

    context 'user' do
      scenario 'get notified about new answers to subscribed question' do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
          click_on 'Subscribe'
        end

        Capybara.using_session('author') do
          sign_in(user)
          visit question_path(question)

          within '.add-answer' do
            fill_in 'Body', with: 'This is answer to the question'
            click_on 'Write Answer'
          end
        end

        Capybara.using_session('user') do
          sleep(1)
          open_email(user.email)
          expect(current_email).to have_content 'There is a new answer to a subscribed question'
        end
      end

      scenario 'does not get notified about new answers to unsubscribed question' do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
          click_on 'Subscribe'
          click_on 'Unsubscribe'
        end

        Capybara.using_session('author') do
          sign_in(user)
          visit question_path(question)

          within '.add-answer' do
            fill_in 'Body', with: 'This is answer to the question'
            click_on 'Write Answer'
          end
        end

        Capybara.using_session('user') do
          sleep(1)
          open_email(user.email)
          expect(current_email).to_not have_content 'There is a new answer to a subscribed question'
        end
      end
    end

    after { Sidekiq::Testing.disable! }
  end
end
