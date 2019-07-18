class Answer < ApplicationRecord

  default_scope { order(best: :desc).order(created_at: :asc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def select_best
    question.answers.where(best: true).update_all(best: false)
    self.best = true
    save
  end

end
