class Question < ApplicationRecord
  # в случае удаления вопроса, связанные ответы также удалятся dependent: :destroy
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  # сделаем ограничение на размер заголовка вопроса
  # чтобы пользователи давали вопросам осмысленные названия, но при этом не слишком длинные
  validates :title, length: { in: 10..50 }
  # ограничим размеры самого вопроса
  validates :body, length: { in: 10..1000 }
end
