class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index]

  def index
    render json: @question.answers
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
