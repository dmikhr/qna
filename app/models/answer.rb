class Answer < ApplicationRecord

  # new answers are below older, best is on the top
  default_scope { order(best: :desc).order(created_at: :asc) }

  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def select_best
    Answer.transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end

end
