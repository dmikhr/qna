module Votable
  UPVOTE_VALUE = 1
  DOWNVOTE_VALUE = -1

  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def upvote
    votes.create(value: UPVOTE_VALUE, user: user) if can_vote?(UPVOTE_VALUE)
  end

  def downvote
    votes.create(value: DOWNVOTE_VALUE, user: user) if can_vote?(DOWNVOTE_VALUE)
  end

  def cancel_vote
    votes.where(user: user).destroy_all
  end

  def score
    votes.sum(:value)
  end

  private

  def can_vote?(value)
    # пользователь не может проголосовать одинаково больше 1 раза
    return false if votes.where(user: user).first == value
    # если пользователь до этого дал противоположную оценку текущей, то
    # отменяем предыдущую оценку
    cancel_vote
  end

end
