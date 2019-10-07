class Answer < ApplicationRecord
  include Votable
  include Commentable

  # new answers are below older, best is on the top
  default_scope { order(best: :desc).order(created_at: :asc) }

  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  after_create :send_notification

  def select_best
    Answer.transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
      # изменять статус награды, только если награда была задана автором вопроса
      question.reward.update(user: user) if question.reward
    end
  end

  private

  def send_notification
    NewAnswerNotificationJob.perform_later(question)
  end
end
