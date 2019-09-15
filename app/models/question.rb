class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy, as: :subscribable
  has_one :reward, dependent: :destroy, as: :rewardable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  validates :title, length: { in: 10..150 }
  validates :body, length: { minimum: 10 }

  after_create :calculate_reputation

  # при создании вопроса автор автоматически подписывается на уведомления
  after_create :subscribe_author!

  private

  def subscribe_author!
    subscriptions.create!(user: user)
  end

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
