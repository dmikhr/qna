module Votable

  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  # вызов create решил обернуть в экспешены
  # если вызывать create! например при двойном голосовании - в юнит тестах можно проверять на
  # raise_exception ActiveRecord::RecordInvalid, но feature тесты на аналогичный сценарий будут падать
  # при этом ситуация, когда пользователь попытается проголосовать дважды на мой взгляд типовая
  # например, можно случайно кликнуть 2 раза, поэтому сделал отлов исключения ActiveRecord::RecordInvalid

  def upvote
    begin
      votes.create(value: 1, user: user)
    rescue ActiveRecord::RecordInvalid
      false
    end
  end

  def downvote
    begin
      votes.create(value: -1, user: user)
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
