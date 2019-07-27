class RewardService
  def initialize(user, question)
    @user = user
    @question = question
  end

  def call
    @question.reward.update(user: @user)
  end
end
