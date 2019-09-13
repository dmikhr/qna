class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  def author_of?(item)
    item.user_id == id
  end

  def subscribed?(item)
    subscriptions.exists?(subscribable_id: item.id)
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new.call(auth)
  end

  def create_authorization!(auth)
    self.authorizations.create!(provider: auth.provider, uid: auth.uid)
  end

  def self.create_by_email(email)
    password = Devise.friendly_token[0, 20]
    User.create(email: email, password: password, password_confirmation: password)
  end
end
