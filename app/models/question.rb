class Question < ApplicationRecord
  # в случае удаления вопроса, связанные ответы также удалятся dependent: :destroy
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
