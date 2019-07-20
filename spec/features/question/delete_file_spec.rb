require 'rails_helper'

feature 'User can delete file from his own question' do
  given!(:author_user) { create(:user) }
  given!(:question) { create(:question, :with_file, user: author_user) }

  # прикреплены 2 файла, удаляем только 'rails_helper.rb'
  scenario 'Author deletes file from question', js: true do
    sign_in(author_user)
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
end
