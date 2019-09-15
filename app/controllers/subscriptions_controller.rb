class SubscriptionsController < ApplicationController

  before_action :load_subscription, only: :destroy
  before_action :load_question, only: :create

  authorize_resource

  def create
    @subscription = Subscription.new(subscribable: @question, user: current_user)
    @subscription.save!
  end

  def destroy
    @subscription.destroy
  end

  private

  def subscribable_id
    params.require(:id)
  end

  def load_question
    @question = Question.find(subscribable_id)
  end

  def load_subscription
    @subscription = Subscription.find_by!(subscribable_id: subscribable_id,
                                         subscribable_type: "Question",
                                         user: current_user)
  end
end
