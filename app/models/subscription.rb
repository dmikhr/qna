class Subscription < ApplicationRecord
  belongs_to :user
  # cвязь с вопросом полиморфная, чтобы в перспективе можно было
  # делать подписки и на другие модели (комментарии, голосование, и т.п.)
  belongs_to :subscribable, polymorphic: true
end
