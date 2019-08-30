class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer], user: user

    # голосование: можно голосовать, если user не автор
    # использование блока: http://connect.thinknetica.com/t/13-rails/471/49
    can [:upvote, :cancel_vote, :downvote], Votable do |votable|
      !user.author_of?(votable)
    end

    # автор вопроса может выбрать лучший ответ
    can :select_best, Answer do |answer|
      user.author_of?(answer.question) && !answer.best
    end

    # автор Linkable может удалить ссылку
    can :destroy, Link do |link|
      user.author_of?(link.linkable)
    end

    can :destroy, ActiveStorage::Attachment do |file|
      user.author_of?(file.record)
    end
  end
end
