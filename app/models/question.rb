class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  has_many_attached :files

  validates :title, :body, presence: true
  validates :title, length: { in: 10..150 }
  validates :body, length: { minimum: 10 }
end
