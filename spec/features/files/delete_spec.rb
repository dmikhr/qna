require 'rails_helper'

feature 'User can delete file from his own question' do
  given!(:author_user) { create(:user) }
  given!(:question) { create(:question, :with_files, user: author_user) }
  given!(:question_without_files) { create(:question, user: author_user) }
  given!(:answer) { create(:answer, :with_files, question: question_without_files, user: author_user) }

  describe 'Author deletes file', js: true do

    background { sign_in(author_user) }

    # прикреплены 2 файла, удаляем только 'rails_helper.rb'
    scenario 'from question' do
      visit questions_path

      expect(page).to have_content 'rails_helper.rb'
      expect(page).to have_content 'spec_helper.rb'

      within "div#question_id_#{question.id}" do
        click_on 'Edit question'

        within "div#edit_file_id_#{question.files.first.id}" do
          click_on 'Delete file'
        end

        click_on 'Save question'
      end

      expect(page).to_not have_content 'rails_helper.rb'
      expect(page).to have_content 'spec_helper.rb'
    end

    # сценарии "пользователь пытается прикрепить файл не к своему вопросу" и
    # "неавторизованный пользователь пытается прикрепить файл" реализованы
    # только на уровне тестирования контроллеров, т.к. кнопка прикрепления файла находится в форме редактирования,
    # т.е. для feature тестов эти сценарии проверяет тест из question/edit_spec.rb на отсутствие ссылки 'Edit question'
    # аналогично для ответов

    scenario 'from answer' do
      visit question_path(question_without_files)

      expect(page).to have_content 'rails_helper.rb'
      expect(page).to have_content 'spec_helper.rb'

      within "div#answer_id_#{answer.id}" do
        click_on 'Edit'

        within "div#edit_file_id_#{answer.files.first.id}" do
          click_on 'Delete file'
        end

        click_on 'Save'
      end

      expect(page).to_not have_content 'rails_helper.rb'
      expect(page).to have_content 'spec_helper.rb'
    end
  end
end
