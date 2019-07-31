module Votable

  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  # убрал cancel_vote из can_vote? и сам этот метод
  # но cancel_vote все равно нужен в upvote и downvote, чтобы реализовать случай, когда
  # пользователь меняет голос на противоположный
  # сценарий: пользователь проголосовал за, потом решил проголосовать против.
  # В таком случае валидация на уникальность не даст так сделать, т.к. юзер уже голосовал, значит
  # нужно сначала отменить старый голос, для этого используется cancel_vote в методах upvote и downvote

  def upvote
    cancel_vote
    begin
      votes.create!(value: 1, user: user)
    rescue ActiveRecord::RecordInvalid
      false
    end
  end

  def downvote
    cancel_vote
    begin
      votes.create!(value: -1, user: user)
    rescue ActiveRecord::RecordInvalid
      false
    end
  end

  def cancel_vote
    votes.where(user: user).destroy_all
  end

  def score
    votes.sum(:value)
  end
end
