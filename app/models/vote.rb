class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user, presence: true, uniqueness: { scope: [:votable_id, :votable_type] }

  validates :value, presence: true
  validates :value, numericality: { only_integer: true }
end
