class Reward < ApplicationRecord
  # связь с вопросом полиморфная, чтобы иметь возможность в будущем
  # назначать награды за ответы, комментарии, и.т.п.
  belongs_to :rewardable, polymorphic: true
  belongs_to :user, optional: true

  has_one_attached :picture

  validates :name, presence: true
  
end
