class Answer < ApplicationRecord

  # new answers are below older, best is on the top
  default_scope { order(best: :desc).order(created_at: :asc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def select_best
    Answer.transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
    end
  end

end
