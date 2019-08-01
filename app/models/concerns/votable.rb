module Votable

  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def upvote
    begin
      votes.create!(value: 1, user: user)
    rescue ActiveRecord::RecordInvalid
      false
    end
  end

  def downvote
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
